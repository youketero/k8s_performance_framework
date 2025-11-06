#!/usr/bin/env bash
set -euo pipefail
_log() { printf '[%(%F %T)T] %s\n' -1 "$*" >&2; }

# ========================================
# CONFIGURATION
# ========================================

NAMESPACE="performance"
JMX_FILE="Google_basic.jmx"
THREADS=10
RAMP_UP=10
DURATION=120
CUSTOM_PARAMETERS="TEST_DELAY:10"

# ========================================
# ARGUMENT PARSER
# ========================================

while [[ $# -gt 0 ]]; do
  case "$1" in
    --namespace) NAMESPACE="$2"; shift 2 ;;
    --jmx) JMX_FILE="$2"; shift 2 ;;
    --threads) THREADS="$2"; shift 2 ;;
    --ramp-up) RAMP_UP="$2"; shift 2 ;;
    --duration) DURATION="$2"; shift 2 ;;
    --custom) CUSTOM_PARAMETERS="$2"; shift 2 ;;
    --help)
      echo "Usage: $0 [--namespace ns] [--jmx file.jmx] [--threads N] [--ramp-up sec] [--duration sec] [--custom param:value,...]"
      exit 0 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

# ========================================
# CLONE TEST REPOSITORY
# ========================================

if [ ! -d "jmeter_test" ]; then
  _log "📥 Cloning JMeter test repository..."
  git clone -b main https://github.com/youketero/jmeter_test.git
fi
cd jmeter_test || exit 1

# ========================================
# GET POD INFORMATION
# ========================================

_log "🔍 Getting pod info in namespace: ${NAMESPACE}"
MASTER_POD=$(kubectl get pod -n "$NAMESPACE" -l jmeter_mode=master -o jsonpath="{.items[0].metadata.name}")
read -r -a SLAVE_PODS <<<"$(kubectl get pod -n "$NAMESPACE" -l jmeter_mode=slave -o jsonpath='{range.items[*]}{.metadata.name} {end}')"

if [ -z "$MASTER_POD" ]; then
  _log "❌ Master pod not found!"
  exit 1
fi

if [ ${#SLAVE_PODS[@]} -eq 0 ]; then
  _log "❌ No slave pods found!"
  exit 1
fi

_log "✅ Master: $MASTER_POD"
_log "✅ Slaves: ${SLAVE_PODS[*]}"

# ========================================
# LOCATE FILES
# ========================================

FILE_PATH=$(find "$(pwd)" -name "$JMX_FILE" | head -n 1)
if [ -z "$FILE_PATH" ]; then
  _log "❌ JMX file not found: $JMX_FILE"
  exit 1
fi

JMETER_DIR=$(kubectl exec -n "$NAMESPACE" -c jmmaster "$MASTER_POD" -- sh -c 'find /opt -maxdepth 1 -type d -name "apache-jmeter*" | head -n1')
_log "📁 JMeter dir: $JMETER_DIR"
_log "📁 Local JMX file: $FILE_PATH"

# ========================================
# FILE COPY FUNCTION
# ========================================

copy_file_to_pod() {
  local namespace="$1" local_path="$2" pod="$3" dest_path="$4" container="${5:-jmslave}"
  _log "📤 Copying '${local_path}' → ${pod}:${dest_path} (container=${container})"

  if [ ! -f "$local_path" ]; then
    _log "⚠️ Local file missing: $local_path"
    return 2
  fi

  local dest_dir dest_base
  dest_dir="$(dirname "$dest_path")"
  dest_base="$(basename "$dest_path")"

  _log "🧭 Ensuring destination directory exists: ${dest_dir}"
  kubectl -n "$namespace" exec -i "$pod" -c "$container" -- sh -c "mkdir -p -- '$dest_dir'" || {
    _log "❌ Failed to create directory ${dest_dir} inside ${pod}"
    return 3
  }

  if tar cf - -C "$(dirname "$local_path")" "$(basename "$local_path")" | \
     kubectl -n "$namespace" exec -i "$pod" -c "$container" -- sh -c "tar xf - -C '$dest_dir' 2>&1"; then
    if [ "$(basename "$local_path")" != "$dest_base" ]; then
      kubectl -n "$namespace" exec -i "$pod" -c "$container" -- sh -c "mv -f '$dest_dir/$(basename "$local_path")' '$dest_dir/$dest_base'"
    fi
    _log "✅ Copied successfully via tar."
  else
    _log "⚠️ tar copy failed, retrying with kubectl cp..."
    if ! kubectl -n "$namespace" cp -c "$container" "$local_path" "${pod}:${dest_dir}/${dest_base}" 2>/tmp/kubectl_cp_err.log; then
      _log "❌ kubectl cp failed:"
      sed -n '1,100p' /tmp/kubectl_cp_err.log
      return 7
    fi
    _log "✅ kubectl cp succeeded."
  fi
}

# ========================================
# UPLOAD CSV FILES TO SLAVES
# ========================================

upload_csv_to_pods() {
  local namespace="$1" jmeter_dir="$2" 
  local -n slave_pods_ref=$3
  local slave_num=${#slave_pods_ref[@]}
  _log "📂 Uploading CSVs to ${slave_num} slave pods..."

  mapfile -t csv_files_split < <(find "$(pwd)" -type f -name "*.csv" ! -name "*_nosplit*.csv" 2>/dev/null || true)
  mapfile -t csv_files_no_split < <(find "$(pwd)" -type f -name "*_nosplit*.csv" 2>/dev/null || true)

  if [ ${#csv_files_split[@]} -gt 0 ]; then
    for csv in "${csv_files_split[@]}"; do
      local base_name lines_total lines_per_split
      base_name="$(basename "$csv")"
      lines_total=$(wc -l < "$csv" | tr -d ' ')
      lines_per_split=$(( (lines_total + slave_num - 1) / slave_num ))
      _log "✂️ Splitting '$csv' (${lines_total} lines) → ${slave_num} parts (${lines_per_split} each)"
      split --suffix-length=2 -d -l "$lines_per_split" "$csv" "${csv}."

      for i in "${!slave_pods_ref[@]}"; do
        local part pod dest
        part=$(printf "%s.%02d" "$csv" "$i")
        pod="${slave_pods_ref[$i]}"
        dest="${jmeter_dir}/bin/${base_name}"
        [ -f "$part" ] && copy_file_to_pod "$namespace" "$part" "$pod" "$dest" "jmslave"
      done
      rm -f "${csv}".??
    done
  fi

  if [ ${#csv_files_no_split[@]} -gt 0 ]; then
    for csv in "${csv_files_no_split[@]}"; do
      local base_name dest
      base_name="$(basename "$csv")"
      dest="${jmeter_dir}/bin/${base_name}"
      for pod in "${slave_pods_ref[@]}"; do
        copy_file_to_pod "$namespace" "$csv" "$pod" "$dest" "jmslave"
      done
    done
  fi
  _log "✅ Finished uploading CSVs."
}

upload_csv_to_pods "$NAMESPACE" "$JMETER_DIR" SLAVE_PODS

# ========================================
# PREPARE SLAVE START SCRIPT
# ========================================

cat > jmeter_injector_start.sh <<'EOF'
#!/bin/bash
cd "$1" || exit 1
trap 'exit 0' SIGUSR1
jmeter-server -Dserver.rmi.localport=50000 -Dserver_port=1099 -Jserver.rmi.ssl.disable=true >> jmeter-injector.out 2>> jmeter-injector.err &
wait
EOF
chmod +x jmeter_injector_start.sh

_log "🚀 Starting JMeter injectors on slaves..."

for POD in "${SLAVE_PODS[@]}"; do
  _log "➡️  ${POD}"
  jmx_name=$(basename "$FILE_PATH")

  cat "$FILE_PATH" | kubectl -n "$NAMESPACE" exec -i -c jmslave "$POD" -- sh -c "cat > '${JMETER_DIR}/bin/${jmx_name}'"
  cat jmeter_injector_start.sh | kubectl -n "$NAMESPACE" exec -i -c jmslave "$POD" -- sh -c "cat > '${JMETER_DIR}/jmeter_injector_start.sh'"
  kubectl -n "$NAMESPACE" exec -c jmslave "$POD" -- sh -c "chmod +x '${JMETER_DIR}/jmeter_injector_start.sh'"
  kubectl -n "$NAMESPACE" exec -c jmslave "$POD" -- sh -c "'${JMETER_DIR}/jmeter_injector_start.sh' '${JMETER_DIR}'" &
done

# ========================================
# BUILD CUSTOM PARAMETERS
# ========================================

CUSTOM_LINE=""
IFS=',' read -ra PARAMS <<< "$CUSTOM_PARAMETERS"
for PARAM in "${PARAMS[@]}"; do
  KEY="${PARAM%%:*}"
  VAL="${PARAM##*:}"
  CUSTOM_LINE+=" -G${KEY}=${VAL}"
done

# ========================================
# GET SLAVE IPs
# ========================================

_log "📡 Fetching slave pod IPs..."
SLAVE_IPS=$(kubectl -n "$NAMESPACE" get pods -l jmeter_mode=slave -o jsonpath='{.items[*].status.podIP}' | tr ' ' ',')
if [ -z "$SLAVE_IPS" ]; then
  _log "❌ No slave IPs found!"
  kubectl -n "$NAMESPACE" get pods -l jmeter_mode=slave -o wide
  exit 1
fi
_log "✅ Slave IPs: $SLAVE_IPS"

# ========================================
# CREATE MASTER TEST SCRIPT
# ========================================

cat > load_test.sh <<EOF
#!/bin/bash
cd ${JMETER_DIR}
trap 'exit 0' SIGUSR1
echo "Running JMeter test with slaves: ${SLAVE_IPS}"
jmeter -n -t ${JMETER_DIR}/bin/${JMX_FILE} \
  -l /jmeter/report_${JMX_FILE}_\$(date +"%F_%H%M%S").csv \
  -j /jmeter/report_${JMX_FILE}_\$(date +"%F_%H%M%S").jtl \
  -GDURATION=${DURATION} -GTHREADS=${THREADS} -GRAMP_UP=${RAMP_UP} ${CUSTOM_LINE} \
  -Dserver.rmi.ssl.disable=true --remoteexit --remotestart ${SLAVE_IPS} >> jmeter-master.out 2>> jmeter-master.err &
wait
EOF

# ========================================
# COPY TO MASTER AND START DETACHED TEST
# ========================================

_log "📤 Copying test files to master pod..."
cat load_test.sh | kubectl -n "$NAMESPACE" exec -i -c jmmaster "$MASTER_POD" -- bash -c "cat > '${JMETER_DIR}/load_test.sh' && chmod +x '${JMETER_DIR}/load_test.sh'"
cat "$FILE_PATH" | kubectl -n "$NAMESPACE" exec -i -c jmmaster "$MASTER_POD" -- bash -c "cat > '${JMETER_DIR}/bin/$(basename "$FILE_PATH")'"

_log "🏁 Starting test on master pod (detached mode)..."
kubectl -n "$NAMESPACE" exec -c jmmaster "$MASTER_POD" -- bash -c "
  cd "${JMETER_DIR}" && ./load_test.sh > /jmeter/detached_run.log 2>&1 &
"

if [ $? -eq 0 ]; then
  _log "✅ Load test started in detached mode. Logs: /jmeter/detached_run.log"
else
  _log "❌ Failed to start load test."
fi

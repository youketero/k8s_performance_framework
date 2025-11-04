#!/usr/bin/env bash
set -euo pipefail

log() { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }

NAMESPACE="${1:-performance}"

log "🔹 Using namespace: ${NAMESPACE}"

# === Find master pod ===
log "🔍 Searching for JMeter master pod..."
MASTER_POD=$(kubectl get pod -n "$NAMESPACE" -l jmeter_mode=master \
  -o jsonpath="{.items[0].metadata.name}" 2>/dev/null || true)

if [[ -z "$MASTER_POD" ]]; then
  log "❌ Master pod not found in namespace '$NAMESPACE'"
  exit 1
fi
log "✅ Found JMeter master pod: ${MASTER_POD}"

# === Find JMeter directory ===
JMETER_DIR=$(kubectl exec -n "$NAMESPACE" -c jmmaster "$MASTER_POD" \
  -- sh -c 'find /opt -maxdepth 1 -type d -name "apache-jmeter*" | head -n1' | tr -d '\r')

if [[ -z "$JMETER_DIR" ]]; then
  log "❌ Could not locate JMeter directory inside master pod"
  exit 1
fi
log "✅ JMeter directory: ${JMETER_DIR}"

# === Attempt graceful stop ===
log "🛑 Attempting graceful JMeter stop via stoptest.sh ..."
if kubectl exec -n "$NAMESPACE" -c jmmaster "$MASTER_POD" -- bash -c "sh '${JMETER_DIR}/bin/stoptest.sh'"; then
  log "✅ stoptest.sh executed successfully."
else
  log "⚠️ stoptest.sh failed or not found. Trying shutdown.sh ..."
  kubectl exec -n "$NAMESPACE" -c jmmaster "$MASTER_POD" -- bash -c "sh '${JMETER_DIR}/bin/shutdown.sh' || true"
fi

# === Wait and verify ===
log "⏳ Waiting 10 seconds for JMeter to terminate..."
sleep 10

if kubectl exec -n "$NAMESPACE" -c jmmaster "$MASTER_POD" -- pgrep -f 'org.apache.jmeter.NewDriver' >/dev/null 2>&1; then
  log "⚠️ JMeter still running — performing force kill..."
  kubectl exec -n "$NAMESPACE" -c jmmaster "$MASTER_POD" -- pkill -9 -f 'org.apache.jmeter.NewDriver' || true
  log "✅ Force kill complete."
else
  log "✅ JMeter stopped successfully."
fi

log "🏁 Done."

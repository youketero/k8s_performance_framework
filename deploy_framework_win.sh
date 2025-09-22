#--------------Creating namespace----------------
echo "Creating namespace started"
kubectl apply -f ./namespace.yaml
echo "✅ Namespace created"
#--------------Deploying jenkins-----------------
echo "Creating namespace started"
kubectl apply -f ./jenkins.yaml
echo "✅ Jenkins pod created"
#--------------Deploying eck---------------------
echo "Deploying of ECK started"
kubectl create -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml
kubectl get -n elastic-system pods
kubectl apply -f ./elasticsearch.yaml
kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n performance --timeout=180s
kubectl apply -f ./elasticsearch.yaml
kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n performance --timeout=180s
kubectl apply -f ./kibana.yaml
kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n performance --timeout=180s
kubectl apply -f ./logstash.yaml
kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n performance --timeout=180s
kubectl apply -f ./filebeat.yaml
kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n performance --timeout=180s
kubectl apply -f ./metricbeat.yaml
kubectl wait --for=condition=ready pod -l elasticsearch.k8s.elastic.co/cluster-name=elasticsearch -n performance --timeout=180s
echo "✅ ECK pod's is running"
#--------------Deploying jmeter cluster----------
echo "Starting deploying of jmeter cluster" 
kubectl -n performance apply -f ./jmeter_m.yaml
kubectl -n performance wait --for=condition=Ready pod -l jmeter_mode=master --timeout=120s
kubectl -n performance get pods -l jmeter_mode=master -o wide
kubectl -n performance apply -f ./jmeter_s.yaml
kubectl -n performance wait deployment jmeter-slaves --for=condition=Available --timeout=2m
echo "✅ Jmeter pod's is running"
#--------------Deploying fastapp application-----
echo "Starting deploying of fastapp application" 
kubectl -n performance apply -f ./fastapp.yaml
echo "✅ Fastapp pod is running"
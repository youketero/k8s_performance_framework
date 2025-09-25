#--------------Creating namespace----------------
echo "Creating namespace started"
kubectl apply -f .namespaces/performance_ns.yaml
echo "✅ Namespace created"
#--------------Deploying jenkins-----------------
echo "Creating namespace started"
kubectl apply -k ./jenkins
echo "✅ Jenkins pod created"
#--------------Deploying eck---------------------
echo "Deploying of ECK started"
kubectl create -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml
kubectl get -n elastic-system pods
kubectl apply -f ./elasticsearch.yaml
kubectl apply -f ./elasticsearch.yaml
kubectl apply -f ./kibana.yaml
kubectl apply -f ./logstash.yaml
kubectl apply -f ./filebeat.yaml
kubectl apply -f ./metricbeat.yaml
echo "✅ ECK pod's is running"
#--------------Deploying jmeter cluster----------
echo "Starting deploying of jmeter cluster" 
kubectl apply -k ./jmeter
kubectl -n performance wait --for=condition=Ready pod -l jmeter_mode=master --timeout=120s
kubectl -n performance get pods -l jmeter_mode=master -o wide
echo "✅ Jmeter pod's is running"
#--------------Deploying fastapp application-----
echo "Starting deploying of fastapp application" 
kubectl -n performance apply -f ./fastapp.yaml
echo "✅ Fastapp pod is running"
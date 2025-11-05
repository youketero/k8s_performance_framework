#--------------Creating namespace----------------
echo "Creating namespace started"
kubectl apply -f ./namespaces/performance_ns.yaml
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
kubectl apply -k ./eck
echo "✅ ECK pod's is running"
#--------------Deploying jmeter cluster----------
echo "Starting deploying of jmeter cluster" 
kubectl apply -k ./jmeter
echo "✅ Jmeter pod's is running"
#--------------Deploying fastapp application-----
echo "Starting deploying of fastapp application" 
kubectl apply -k ./fast_api
echo "✅ Fastapp pod is running"
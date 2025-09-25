#--------------Deploying jenkins-----------------
echo "Creating namespace started"
kubectl apply -f ./namespaces/performance_ns.yaml
kubectl apply -k ./jenkins
echo "✅ Jenkins pod created"
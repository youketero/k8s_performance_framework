#--------------Deploying jenkins-----------------
echo "Fastapp pod started"
kubectl apply -f ./namespaces/performance_ns.yaml
kubectl apply -k ./fast_api
echo "✅ Fastapp pod created"
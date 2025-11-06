#--------------Deploying jmeter cluster-----------------
echo "Deploying k6 cluster started"
kubectl apply -f ./namespaces/performance_ns.yaml
kubectl apply -k ./k6
echo "✅ K6 cluster up and running"
#--------------Deploying jenkins-----------------
echo "Deploying jmeter cluster started"
kubectl apply -f ./namespaces/performance_ns.yaml
kubectl apply -k ./jmeter
echo "✅ Jmeter cluster up and running"
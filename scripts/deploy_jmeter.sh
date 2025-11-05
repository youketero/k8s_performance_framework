#--------------Deploying jmeter cluster-----------------
echo "Deploying jmeter cluster started"
kubectl apply -k ./jmeter
echo "✅ Jmeter cluster up and running"
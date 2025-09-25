#--------------Stopping jmeter cluster-----------------
echo "Deleting jmeter cluster started"
kubectl delete -k ./jmeter
echo "✅ Deleting jmeter cluster ended"
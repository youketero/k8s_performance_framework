#--------------Stopping k6 cluster-----------------
echo "Deleting jk6 cluster started"
kubectl delete -k ./k6
echo "✅ Deleting k6 cluster ended"
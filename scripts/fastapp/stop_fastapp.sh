#--------------Stopping fastapp application-----------------
echo "Creating fastapp started"
kubectl delete -k ./fast_api
echo "✅ Fastapp components up and running"
#--------------Deploying fastapp-----------------
echo "Fastapp pod started"
kubectl apply -k ./fast_api
echo "✅ Fastapp pod created"
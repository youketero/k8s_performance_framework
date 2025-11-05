#--------------Creating namespace---------------------
echo "Creating namespace started"
kubectl apply -f ./namespaces/performance_ns.yaml
echo "✅ Namespace created"
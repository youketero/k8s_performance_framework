#--------------Deploying jenkins-----------------
echo "Creating namespace started"
kubectl delete -k ./jenkins
echo "✅ Jenkins pod created"
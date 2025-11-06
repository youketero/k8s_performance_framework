#--------------Deploying jenkins-----------------
echo "Creating namespace started"
kubectl apply -k ./jenkins
echo "✅ Jenkins pod created"
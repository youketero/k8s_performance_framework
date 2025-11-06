#--------------Deploying jenkins-----------------
echo "Creating jenkins started"
kubectl delete -k ./jenkins
echo "✅ Jenkins components up and running"
#--------------Deploying eck---------------------
echo "Deleteting of ECK cluster started"
kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml || true
kubectl delete -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml || true
kubectl delete crd elasticsearches.elasticsearch.k8s.elastic.co --ignore-not-found=true
kubectl delete crd kibanas.kibana.k8s.elastic.co --ignore-not-found=true
kubectl delete crd beats.beat.k8s.elastic.co --ignore-not-found=true
kubectl delete crd agents.agent.k8s.elastic.co --ignore-not-found=true
kubectl delete crd enterprisesearches.enterprisesearch.k8s.elastic.co --ignore-not-found=true
kubectl delete crd stackconfigpolicies.stackconfigpolicy.k8s.elastic.co --ignore-not-found=true
kubectl delete -k ./eck
echo "✅ Deleteting of ECK cluster ended"
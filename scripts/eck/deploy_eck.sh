#!/bin/bash
#--------------Deploying ECK---------------------
LOAD_TOOL=${1:-jmeter} 
echo "Deploying of ECK started"
kubectl create -f https://download.elastic.co/downloads/eck/3.1.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/3.1.0/operator.yaml
kubectl get -n elastic-system pods
echo "Applying overlay for ${LOAD_TOOL}..."
kubectl apply -k ./eck/overlays/${LOAD_TOOL}
echo "✅ ECK components deployed for ${LOAD_TOOL}"
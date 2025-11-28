#!/bin/bash
#--------------Deploying ECK---------------------
for i in $@
do 
    kubectl apply -f ./utils/cleanpvc_${i}.yaml -n performance
done
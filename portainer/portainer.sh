#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

# Install via helm
helm repo add portainer https://portainer.github.io/k8s/
helm repo update
helm install ${NAME} portainer/portainer -n ${NAMESPACE} --create-namespace \
  --set persistence.storageClass=${STORAGE_CLASS}

# Verify
echo "Use command 'kubectl -n ${NAMESPACE} get pod' to check if that the deployment succeeded:"
kubectl -n ${NAMESPACE} get pod

export NODE_PORT=$(kubectl get --namespace ${NAMESPACE} -o jsonpath="{.spec.ports[1].nodePort}" services ${NAME})
export NODE_IP=$(kubectl get nodes --namespace ${NAMESPACE} -o jsonpath="{.items[0].status.addresses[0].address}")
echo https://$NODE_IP:$NODE_PORT
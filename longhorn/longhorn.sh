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
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install ${NAME} longhorn/longhorn -n ${NAMESPACE} --create-namespace

# Verify
echo "Use command 'kubectl -n ${NAMESPACE} get pod' to check if that the deployment succeeded:"
kubectl -n ${NAMESPACE} get pod

#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

helm uninstall ${NAME} -n ${NAMESPACE}
kubectl delete ns ${NAMESPACE}
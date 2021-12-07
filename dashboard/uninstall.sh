#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

k3s kubectl delete ns ${NAMESPACE}
k3s kubectl delete clusterrolebinding ${NAME}
k3s kubectl delete clusterrole ${NAME}
#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

# Patch
kubectl annotate ingress ${NAME}-frontend -n ${NAMESPACE} --overwrite traefik.ingress.kubernetes.io/router.middlewares=kube-system-traefik-basicauth@kubernetescrd

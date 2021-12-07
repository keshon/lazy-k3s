#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

# Delete existing secret
kubectl delete secret traefik-basicauth-secret -n ${NAMESPACE}

# Add middleware
cat <<EOF | kubectl apply -f -
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: traefik-basicauth
  namespace: ${NAMESPACE}
spec:
  basicAuth:
    secret: traefik-basicauth-secret
EOF

# Add secret
# Requires 'auth' file generated with htpasswd
kubectl create secret generic traefik-basicauth-secret --from-file auth -n ${NAMESPACE}
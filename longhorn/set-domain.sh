#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

# Apply
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  namespace: ${NAMESPACE}
  name: ${NAME}-frontend
  annotations:
    kubernetes.io/ingress.class: "${INGRESS_CLASS}"
spec:
  rules:
  - host: ${HOST}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: ${NAME}-frontend
            port:
              number: 80
EOF

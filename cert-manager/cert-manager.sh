#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

# Cert manager https://pascalw.me/blog/2019/07/02/k3s-https-letsencrypt.html
# and this https://www.thebookofjoel.com/k3s-cert-manager-letsencrypt
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml

cat <<EOF | kubectl apply -f -
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration, update to your own.
    email: ${LE_EMAIL}
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    # An empty 'selector' means that this solver matches all domains
    - selector: {}
      http01:
        ingress: {}
EOF

# Verify
echo "Use command 'kubectl -n ${NAMESPACE} get services -o wide' to check if External IP is assigned:"
kubectl -n ${NAMESPACE} get services -o wide
kubectl describe clusterissuer letsencrypt-prod
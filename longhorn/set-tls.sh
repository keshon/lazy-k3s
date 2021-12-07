#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)
else
    echo ".env file not found!"
    exit 0
fi

# Delete old secret key
kubectl delete secret ${HOST//./-}-tls -n ${NAMESPACE}

# Patch
kubectl annotate ingress ${NAME}-frontend -n ${NAMESPACE} --overwrite cert-manager.io/cluster-issuer=letsencrypt-prod
kubectl patch ingress ${NAME}-frontend -n ${NAMESPACE} -p '{"spec":{"tls":[{"hosts":["'${HOST}'"],"secretName":"'${HOST//./-}'-tls"}]}}'

# Verify
echo
echo "*** cert details ***"
echo
kubectl describe certificate ${HOST//./-}-tls -n ${NAMESPACE}
echo
echo "*** cert requests ***"
echo
kubectl get certificaterequests -n ${NAMESPACE}
echo
echo "*** events ***"
echo
kubectl get events -n ${NAMESPACE}

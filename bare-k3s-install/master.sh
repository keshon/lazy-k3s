#!/bin/bash

# Read .env
if [ -f .env ]
then
    export $(cat .env | sed 's/#.*//g' | xargs)

    # Set Hostname
    if [ -z "$HOSTNAME" ]
    then
        sudo hostnamectl set-hostname $HOSTNAME
        echo "New hostname is:" $(hostname)
    fi
else
    echo ".env file not found!"
fi

# Install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# Install Kubernetes on master node
curl -sfL https://get.k3s.io | sh -

# Echo info for worker node(s)
k3s_url="https://${PUBLIC_IP}:6443"
k3s_token=$(cat /var/lib/rancher/k3s/server/node-token)
echo
echo "*** Copy to worker: ***"
echo
echo "curl -sfL https://get.k3s.io | K3S_URL=${k3s_url} K3S_TOKEN=${k3s_token} sh - "
echo "curl -sfL https://get.k3s.io | K3S_URL=${k3s_url} K3S_TOKEN=${k3s_token} sh - " > to-worker

# Fix potential issue with helm. More on that: https://github.com/k3s-io/k3s/issues/1126#issuecomment-560504204
kubectl config view --raw >~/.kube/config
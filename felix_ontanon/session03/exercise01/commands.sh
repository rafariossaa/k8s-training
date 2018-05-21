#!/bin/bash

export KUBECONFIG=~/.kube/sandbox.conf
export SANDBOX_IP=35.173.186.247

mkdir -p ./certs

# dbarranco generates key and cert req locally
openssl genrsa -out ./certs/dbarranco.key 2048
openssl genrsa -out ./certs/jsalmeron.key 2048
openssl genrsa -out ./certs/juan.key 2048
openssl req -new -key ./certs/dbarranco.key -out ./certs/dbarranco.csr -subj "/CN=dbarranco/O=sre"
openssl req -new -key ./certs/jsalmeron.key -out ./certs/jsalmeron.csr -subj "/CN=jsalmeron/O=tech-lead/O=dev"
openssl req -new -key ./certs/juan.key -out ./certs/juan.csr -subj "/CN=juan/O=dev/O=api"

scp -i ~/.ssh/felix_ontanon.pem ./certs/dbarranco.csr ./certs/jsalmeron.csr ./certs/juan.csr bitnami@$SANDBOX_IP:/tmp

#
# This part is done on the server side
#

sudo openssl x509 -req -in /tmp/dbarranco.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/dbarranco.crt  -days 500
sudo openssl x509 -req -in /tmp/jsalmeron.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/jsalmeron.crt  -days 500
sudo openssl x509 -req -in /tmp/juan.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/juan.crt  -days 500

#
# This part is done again on the client side
#

scp -i ~/.ssh/felix_ontanon.pem bitnami@$SANDBOX_IP:/tmp/dbarranco.crt ./certs/dbarranco.crt
scp -i ~/.ssh/felix_ontanon.pem bitnami@$SANDBOX_IP:/tmp/jsalmeron.crt ./certs/jsalmeron.crt
scp -i ~/.ssh/felix_ontanon.pem bitnami@$SANDBOX_IP:/tmp/juan.crt ./certs/juan.crt
scp -i ~/.ssh/felix_ontanon.pem bitnami@$SANDBOX_IP:/etc/kubernetes/pki/ca.crt ./certs/ca.crt

# Add new kubectl context

kubectl config set-cluster sandbox --certificate-authority=./certs/ca.crt --embed-certs=true --server=https://${SANDBOX_IP}:6443
kubectl config set-credentials dbarranco --client-certificate=./certs/dbarranco.crt --client-key=./certs/dbarranco.key --embed-certs=true
kubectl config set-credentials jsalmeron --client-certificate=./certs/jsalmeron.crt --client-key=./certs/jsalmeron.key --embed-certs=true
kubectl config set-credentials juan --client-certificate=./certs/juan.crt --client-key=./certs/juan.key --embed-certs=true

# Set new context and try 
kubectl config set-context dbarranco-sandbox --cluster=sandbox --user=dbarranco
kubectl config set-context jsalmeron-sandbox --cluster=sandbox --user=jsalmeron
kubectl config set-context juan-sandbox --cluster=sandbox --user=juan

# Create namespaces 

kubectl config use-context kubernetes-admin
kubectl create ns team-vision
kubectl create ns team-api
 
# Create roles and rolebindings 

kubectl create -f team-api-roles.yaml
kubectl create -f team-vision-roles.yaml

# Let's try the configuration

# Salme should be to create resources in both spaces, except secrets
kubectl config use-context jsalmeron-sandbox
kubectl --namespace=team-vision create configmap jsalmeron-config --from-literal=foo=bar
kubectl --namespace=team-api create configmap jsalmeron-config --from-literal=foo=bar
kubectl --namespace=team-vision get configmap
kubectl --namespace=team-api get configmap
kubectl --namespace=team-vision create secret generic jsalmeron-secret --from-literal=key1=supersecret # Fails with the error below
# Error from server (Forbidden): secrets is forbidden: User "jsalmeron" cannot create secrets in the namespace "team-vision"

# Juan should see both namespaces and only create resources on team-api
kubectl config use-context juan-sandbox
kubectl --namespace=team-vision get configmap # Shows salme's
kubectl --namespace=team-api get configmap # Shows salme's
kubectl --namespace=team-api create configmap juan-config --from-literal=foo=bar # Works !
kubectl --namespace=team-vision create configmap juan-config --from-literal=foo=bar # Fails with the error below
# Error from server (Forbidden): configmaps is forbidden: User "juan" cannot create configmaps in the namespace "team-vision"

# Dbarranco is the master
kubectl config use-context dbarranco-sandbox
kubectl --namespace=team-vision delete configmap jsalmeron-config # Bye salme !
kubectl --namespace=team-api delete configmap jsalmeron-config # Bye salme !
kubectl --namespace=team-api delete configmap juan-config # Bye juan !
kubectl --namespace=team-vision create secret generic dbarranco-secret --from-literal=key1=supersecret # Works !!

# Assign quota

kubectl create -f quotas.yaml
kubectl create -f limits.yaml
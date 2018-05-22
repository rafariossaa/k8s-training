#!/bin/bash

# 
# IP ADDRESSES
# 

export SANDBOX_IP=35.171.157.107

#
# Execute this in your local machine
#

## Create cert dirs
mkdir -p ~/.certs/kubernetes/sandbox/

## Private key
echo -e "\n\nPRIVATE KEY GENERATION FOR jsalmeron, juan and dbarranco\n\n"
openssl genrsa -out ~/.certs/kubernetes/sandbox/jsalmeron.key 2048
openssl genrsa -out ~/.certs/kubernetes/sandbox/juan.key 2048
openssl genrsa -out ~/.certs/kubernetes/sandbox/dbarranco.key 2048

## Certificate sign request
echo -e "\n\nCERTIFICATE SIGN REQUEST FOR jsalmeron, juan and dbarranco\n\n"
openssl req -new -key ~/.certs/kubernetes/sandbox/jsalmeron.key -out /tmp/jsalmeron.csr -subj "/CN=jsalmeron/O=dev/O=tech-lead"
openssl req -new -key ~/.certs/kubernetes/sandbox/juan.key -out /tmp/juan.csr -subj "/CN=juan/O=dev/O=api"
openssl req -new -key ~/.certs/kubernetes/sandbox/dbarranco.key -out /tmp/dbarranco.csr -subj "/CN=dbarranco/O=sre"

## Copy the requests to the server (NOT THE PROPER WAY)
echo -e "\n\nCOPY THE REQUESTS TO THE SERVER...\n\n"
scp /tmp/jsalmeron.csr /tmp/juan.csr /tmp/dbarranco.csr bitnami@$SANDBOX_IP:/tmp/

#
# This part is done on the server side
#

echo -e "\n\nSIGN CERTIFICATE REQUEST IN SERVER\n\n"
## Certificate
ssh bitnami@$SANDBOX_IP "sudo openssl x509 -req -in /tmp/jsalmeron.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/jsalmeron.crt  -days 500"
ssh bitnami@$SANDBOX_IP "sudo openssl x509 -req -in /tmp/juan.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/juan.crt  -days 500"
ssh bitnami@$SANDBOX_IP "sudo openssl x509 -req -in /tmp/dbarranco.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/dbarranco.crt  -days 500"

#
# This part is done again on the client side
#

# Download the generated certificate (NOT THE PROPER WAY)
echo -e "\n\nDOWNLOAD GENERATED CERTIFICATES\n\n"
scp bitnami@$SANDBOX_IP:/tmp/jsalmeron.crt ~/.certs/kubernetes/sandbox/jsalmeron.crt
scp bitnami@$SANDBOX_IP:/tmp/juan.crt ~/.certs/kubernetes/sandbox/juan.crt
scp bitnami@$SANDBOX_IP:/tmp/dbarranco.crt ~/.certs/kubernetes/sandbox/dbarranco.crt

scp bitnami@$SANDBOX_IP:/etc/kubernetes/pki/ca.crt  ~/.certs/kubernetes/sandbox/ca.crt

# Check the content of the certificates
echo -e "\n\nCHECK CERTIFICATES\n\n"
openssl x509 -in $HOME/.certs/kubernetes/sandbox/jsalmeron.crt -text -noout
openssl x509 -in $HOME/.certs/kubernetes/sandbox/juan.crt -text -noout
openssl x509 -in $HOME/.certs/kubernetes/sandbox/dbarranco.crt -text -noout

# Add new kubectl context

echo -e "\n\nADD NEW KUBECTL CONTEXT\n\n"
kubectl config set-cluster sandbox --certificate-authority=$HOME/.certs/kubernetes/sandbox/ca.crt --embed-certs=true --server=https://${SANDBOX_IP}:6443

# Add new kubectl context for jsalmeron

echo -e "\n\nADD KUBECTL CONTEXT FOR jsakmeron\n\n"
kubectl config set-credentials jsalmeron --client-certificate=$HOME/.certs/kubernetes/sandbox/jsalmeron.crt --client-key=$HOME/.certs/kubernetes/sandbox/jsalmeron.key --embed-certs=true

kubectl config set-context jsalmeron-sandbox --cluster=sandbox --user=jsalmeron --namespace=default

# Add new kubectl context for juan

echo -e "\n\nADD KUBECTL CONTEXT FOR juan\n\n"
kubectl config set-credentials juan --client-certificate=$HOME/.certs/kubernetes/sandbox/juan.crt --client-key=$HOME/.certs/kubernetes/sandbox/juan.key --embed-certs=true

kubectl config set-context juan-sandbox --cluster=sandbox --user=juan --namespace=default

# Add new kubectl context for dbarranco

echo -e "\n\nADD KUBECTL CONTEXT FOR dbarranco\n\n"
kubectl config set-credentials dbarranco --client-certificate=$HOME/.certs/kubernetes/sandbox/dbarranco.crt --client-key=$HOME/.certs/kubernetes/sandbox/dbarranco.key --embed-certs=true

kubectl config set-context dbarranco-sandbox --cluster=sandbox --user=dbarranco --namespace=default


echo -e "\n\nEXPORT KUBECTL CONTEXTS TO FILES\n\n"
kubectl config use-context jsalmeron-sandbox
kubectl config view --flatten --minify > jsalmeron-sandbox.config
kubectl config use-context juan-sandbox
kubectl config view --flatten --minify > juan-sandbox.config
kubectl config use-context dbarranco-sandbox
kubectl config view --flatten --minify > dbarranco-sandbox.config


echo -e "\n\nSET ADMIN KUBE CONTEXT\n\n"
kubectl config use-context kubernetes-admin@kubernetes

#create namespace
kubectl create namespace team-vision
kubectl create namespace team-api

echo -e "\n\nROLE CREATION\n"
kubectl apply -f yaml/





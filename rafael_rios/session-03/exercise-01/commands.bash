#!/bin/bash

# Create namespaces
kubectl create -f 01-ns.yaml

# Create ResourceQuota
kubectl create -f 02-ResourceQuota.yaml

# Create Limits
kubectl create -f 03-Limits.yaml

# Create Roles
kubectl create -f 04-Roles.yaml

# Create Roles
kubectl create -f 04-Roles.yaml

# Create RoleBinding
kubectl create -f 05-RoleBiding.yaml

# Create CSR
mkdir certs
openssl genrsa -out ./certs/jsalmeron.key 2048
openssl req -new -key ./certs/jsalmeron.key -out /tmp/jsalmeron.csr -subj "/CN=jsalmeron/O=devs/O=tech-lead"

openssl genrsa -out ./certs/juan.key 2048
openssl req -new -key ./certs/juan.key -out /tmp/juan.csr -subj "/CN=juan/O=devs/O=api"

openssl genrsa -out ./certs/dbarranco.key 2048
openssl req -new -key ./certs/dbarranco.key -out /tmp/dbarranco.csr -subj "/CN=dbarranco/O=sre"

## 
## All this certifcates handling shouldn't be done this way, it is just a quick and dirty "solution"
##

SANDBOX_IP=34.227.162.230
scp -i ~/kubernetes/Bitnami-Curso/cert/rafael_rios.pem /tmp/*.csr bitnami@$SANDBOX_IP:/tmp/

## Certificate signing
ssh -i ~/kubernetes/Bitnami-Curso/cert/rafael_rios.pem bitnami@$SANDBOX_IP sudo openssl x509 -req -in /tmp/jsalmeron.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/jsalmeron.crt  -days 500 
ssh -i ~/kubernetes/Bitnami-Curso/cert/rafael_rios.pem bitnami@$SANDBOX_IP sudo openssl x509 -req -in /tmp/juan.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/juan.crt  -days 500 
ssh -i ~/kubernetes/Bitnami-Curso/cert/rafael_rios.pem bitnami@$SANDBOX_IP sudo openssl x509 -req -in /tmp/dbarranco.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/dbarranco.crt  -days 500 

# Download the generated certificates
scp -i ~/kubernetes/Bitnami-Curso/cert/rafael_rios.pem bitnami@$SANDBOX_IP:/tmp/*.crt ./certs/
scp -i ~/kubernetes/Bitnami-Curso/cert/rafael_rios.pem bitnami@$SANDBOX_IP:/etc/kubernetes/pki/ca.crt  ./certs/ca.crt

# Add new kubectl context
kubectl config set-cluster sandbox-new --certificate-authority=./certs/ca.crt --embed-certs=true --server=https://${SANDBOX_IP}:6443

kubectl config set-credentials jsalmeron --client-certificate=./certs/jsalmeron.crt --client-key=./certs/jsalmeron.key --embed-certs=true
kubectl config set-context jsalmeron-sandbox --cluster=sandbox-new --user=jsalmeron

kubectl config set-credentials juan --client-certificate=./certs/juan.crt --client-key=./certs/juan.key --embed-certs=true
kubectl config set-context juan-sandbox --cluster=sandbox-new --user=juan

kubectl config set-credentials dbarranco --client-certificate=./certs/dbarranco.crt --client-key=./certs/dbarranco.key --embed-certs=true
kubectl config set-context dbarranco-sandbox --cluster=sandbox-new --user=dbarranco

kubectl config use-context jsalmeron-sandbox
kubectl config use-context juan-sandbox
kubectl config use-context dbarranco-sandbox
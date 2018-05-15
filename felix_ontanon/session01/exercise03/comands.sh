#!/bin/bash

export KUBECONFIG=~/.kube/sandbox.conf
export MY_SANDBOX_IP=35.173.186.247

# One line generation for self signed tls certificates
# From https://major.io/2007/08/02/generate-self-signed-certificate-and-key-in-one-line/#comment-319161 
openssl req -subj '/CN=wordpress-exercise-03.com/O=Bitnami/C=ES' -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out server.crt

kubectl create ns exercise-03
kubectl --namespace=exercise-03 create -f cm.yaml
kubectl --namespace=exercise-03 create -f secret.yaml
kubectl --namespace=exercise-03 create secret tls wordpress-tls --key server.key --cert server.crt
kubectl --namespace=exercise-03 create -f rds-svc.yaml
kubectl --namespace=exercise-03 create -f wordpress-deployment.yaml
kubectl --namespace=exercise-03 create -f wordpress-svc.yaml
kubectl --namespace=exercise-03 create -f ingress.yaml
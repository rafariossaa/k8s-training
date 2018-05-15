#!/bin/bash 
export MY_SANDBOX_IP=54.209.44.48
export KUBECONFIG=~/.kube/sandbox.conf

##Crear espacio de nombre

kubectl create ns exercise-03

##Configuramos configmaps y secrets

kubectl create -f cm.yaml                  
kubectl create -f secrets.yaml

##Create a certificate expressly for the url of this exercise and enter it as a secret
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=wordpress-exercise-03.com"
kubectl create secret tls tls --key /tmp/tls.key --cert /tmp/tls.crt --namespace=exercise-03 

##Configure the application

kubectl create -f wordpress-deployment.yaml      
kubectl create -f rds-svc.yaml
kubectl create -f wordpress-svc.yaml
kubectl create -f ingress.yaml             
kubectl create -f ingress_redirect.yaml     

##Add to our /ect/hots an entry to make to the url

echo "${MY_SANDBOX_IP}   wordpress-exercise-03.com" | sudo tee -a /etc/hosts

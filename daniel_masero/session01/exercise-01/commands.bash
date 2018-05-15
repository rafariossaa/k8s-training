#!/bin/bash 
export MY_SANDBOX_IP=54.90.178.177
export KUBECONFIG=~/.kube/sandbox.conf

##Create namespace

kubectl create ns exercise-01

##Configure configmaps and secrets

kubectl create -f cm.yaml                  
kubectl create -f secrets.yaml

##Configure the application

kubectl create -f mariadb-deployment.yaml  
kubectl create -f wordpress-deployment.yaml
kubectl create -f mariadb-svc.yaml           
kubectl create -f wordpress-svc.yaml
kubectl create -f ingress.yaml             

##Add to our /ect/hots an entry to make to the url

echo "${MY_SANDBOX_IP}   wordpress-exercise-01.com" | sudo tee -a /etc/hosts


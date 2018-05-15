#!/bin/bash

export KUBECONFIG=~/.kube/sandbox.conf
export MY_SANDBOX_IP=35.173.186.247

kubectl create ns exercise-02
kubectl --namespace=exercise-02 create -f cm.yaml
kubectl --namespace=exercise-02 create -f secret.yaml
kubectl --namespace=exercise-02 create -f mariadb-deployment.yaml
kubectl --namespace=exercise-02 create -f mariadb-svc.yaml
kubectl --namespace=exercise-02 create -f wordpress-deployment.yaml
kubectl --namespace=exercise-02 create -f wordpress-canary-deployment.yaml
kubectl --namespace=exercise-02 create -f wordpress-svc.yaml
kubectl --namespace=exercise-02 create -f ingress.yaml
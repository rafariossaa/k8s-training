#!/bin/bash

#Update nginx ingress image
kubectl -n kube-system set image deployments/nginx-ingress-controller nginx-ingress-controller=quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.10.2

#Create namespace
kubectl create namespace exercise-02

#Create configmaps and secrets
kubectl create -n exercise-02 secret generic mariadb-secrets --from-env-file=mariadb.secrets
kubectl create -n exercise-02 secret generic wordpress-secrets --from-env-file=wordpress.secrets
#To update a secret from a file, as workaround use:
#kubectl create secret generic wordpress-secrets --dry-run -o yaml --from-env-file=wordpress.secrets | kubectl replace -f -
kubectl create -n exercise-02 configmap wordpress-config --from-env-file=wordpress.properties
kubectl create -n exercise-02 configmap mariadb-config --from-env-file=mariadb.properties

#Create deployments
kubectl create -n exercise-02 -f mariadb-deployment.yaml
kubectl create -n exercise-02 -f wordpress-deployment.yaml

#Create services
kubectl create -n exercise-02 -f mariadb-service.yaml
kubectl create -n exercise-02 -f wordpress-service.yaml

#Create ingress
kubectl create -n exercise-02 -f ingress.yaml

#Canary
kubectl create -n exercise-02 -f wordpress-canary-deployment.yaml

#After verifying that canary works
#kubectl delete -n exercise-02 -f wordpress-canary-deployment.yaml
#kubectl set image deployments/wordpress-deployment wordpress=bitnami/wordpress:4.9.5

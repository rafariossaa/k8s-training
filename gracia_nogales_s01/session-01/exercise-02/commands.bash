#! /bin/bash

kubectl create ns exercise-02

kubectl create -f mariadb-secret.yaml
kubectl create -f mariadb-deployment.yaml
kubectl expose deployment/mariadb --port=3306 -n exercise-02

kubectl create -f wordpress-deployment.yaml
kubectl expose deployment/wordpress --port=80 --type=NodePort -n exercise-02
kubectl scale --replicas=2 deployment/wordpress -n exercise-02
kubectl create -f ingress.yaml

# 34.227.116.240  wordpress-exercise-02.com
wget http://wordpress-exercise-02.com

kubectl apply -f wordpress-deployment.yaml
kubectl apply -f wordpress-canary-deployment.yaml

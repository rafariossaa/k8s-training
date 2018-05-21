#! /bin/bash

kubectl create ns exercise-01

kubectl create -f mariadb-secret.yaml
kubectl create -f mariadb-deployment.yaml
kubectl expose deployment/mariadb --port=3306 -n exercise-01

kubectl create -f wordpress-deployment.yaml
kubectl expose deployment/wordpress --port=80 --type=NodePort -n exercise-01

kubectl create -f ingress.yaml


wget http://wordpress-exercise-01.com
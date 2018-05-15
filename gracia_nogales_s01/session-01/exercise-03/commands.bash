#!/bin/bash

kubectl create ns exercise-03

kubectl create -f mariadb-secret.yaml
kubectl create -f svc-mariadb.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f wordpress-deployment.yaml
kubectl expose deployment/wordpress --port=80 --type=NodePort -n exercise-03
kubectl scale --replicas=2 deployment/wordpress -n exercise-03
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=wordpress-exercise-03.com"
kubectl create secret tls tls-secret --key tls.key --cert tls.crt
kubectl create -f ingress.yaml

# 34.227.116.240  wordpress-exercise-03.com
wget http://wordpress-exercise-03.com






#!/bin/bash
kubectl create -f ns.yaml
kubectl create -f mariadb-cm.yaml
kubectl create -f wordpress-cm.yaml
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f rds-svc.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-svc.yaml
kubectl get secrets --namespace=exercise03 |grep tls-wp &> /dev/null
if [ $? -ne 0 ];then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=wordpress-exercise-03.com"
  kubectl create secret tls tls-wp --key /tmp/tls.key --cert /tmp/tls.crt --namespace=exercise03
fi
kubectl create -f ingress.yaml

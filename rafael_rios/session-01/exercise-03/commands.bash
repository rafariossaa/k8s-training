#!/bin/bash

# Create namespace exercise-03
kubectl create -f ns.yaml

# Create configmaps
kubectl create -f cm.yaml

# Create secrets
kubectl create -f secrets.yaml
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=wordpress-exercise-03.com" -keyout wordpress.key -out wordpress.crt  
kubectl create secret tls ingress-tls --key wordpress.key --cert wordpress.crt --namespace=exercise-03

# Create remote database service
kubectl create -f rds-svc.yaml

# Create wordpress deployment
kubectl create -f wordpress-deployment.yaml

# Create wordpress service
kubectl create -f wordpress-svc.yaml

# Create ingress
kubectl create -f wordpress-ingress.yaml


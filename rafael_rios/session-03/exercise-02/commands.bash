#!/bin/bash

# Create namespace exercise-01
kubectl create -f ns.yaml

# Create configmaps
kubectl create -f cm.yaml

# Create secrets
kubectl create -f secrets.yaml

# Create database backend deployment
kubectl create -f mariadb-deployment.yaml

# Create database backend service
kubectl create -f mariadb-svc.yaml

# Create wordpress deployment
kubectl create -f wordpress-deployment.yaml

# Create wordpress service
kubectl create -f wordpress-svc.yaml

# Create ingress
kubectl create -f ingress.yaml

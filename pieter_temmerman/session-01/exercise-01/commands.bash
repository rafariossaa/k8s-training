#!/bin/bash

#Create namespace
kubectl create namespace exercise-01

#Create configmaps and secrets
kubectl create -n exercise-01 secret generic mariadb-secrets --from-env-file=mariadb.secrets
kubectl create -n exercise-01 secret generic wordpress-secrets --from-env-file=wordpress.secrets
#To update a secret from a file, as workaround use:
#kubectl create secret generic wordpress-secrets --dry-run -o yaml --from-env-file=wordpress.secrets | kubectl replace -f -
kubectl create -n exercise-01 configmap wordpress-config --from-env-file=wordpress.properties
kubectl create -n exercise-01 configmap mariadb-config --from-env-file=mariadb.properties

#Create deployments
kubectl create -n exercise-01 -f mariadb-deployment.yaml
kubectl create -n exercise-01 -f wordpress-deployment.yaml

#Create services
kubectl create -n exercise-01 -f mariadb-service.yaml
kubectl create -n exercise-01 -f wordpress-service.yaml

#Create ingress
kubectl create -n exercise-01 -f ingress.yaml

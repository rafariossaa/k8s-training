#!/bin/bash

#Create namespace
kubectl create namespace exercise-03

#Create configmaps and secrets
kubectl create -n exercise-03 secret generic wordpress-secrets --from-env-file=wordpress.secrets
#To update a secret from a file, as workaround use:
#kubectl create secret generic wordpress-secrets --dry-run -o yaml --from-env-file=wordpress.secrets | kubectl replace -f -
kubectl create -n exercise-03 configmap wordpress-config --from-env-file=wordpress.properties

#Create deployments
kubectl create -n exercise-03 -f wordpress-deployment.yaml

#Create services
kubectl create -n exercise-03 -f rds-service.yaml
kubectl create -n exercise-03 -f wordpress-service.yaml

#Create a and add SSL certificate keypair ()
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=wordpress-exercise-03.com"
kubectl create -n exercise-03 secret tls tls-store --key /tmp/tls.key --cert /tmp/tls.crt

#Create ingress
kubectl create -n exercise-03 -f ingress.yaml

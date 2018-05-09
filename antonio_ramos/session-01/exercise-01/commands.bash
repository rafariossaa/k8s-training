#!/bin/bash
echo Create our namespace
kubectl create ns exercise-01

echo List namespace to check it is created
kubectl get ns

echo Create our secret for mariadb 
kubectl create -f mariadb-secret.yaml

echo Create our secret for wordpress 
kubectl create -f wordpress-secret.yaml

echo List created secret
kubectl get secret --namespace=exercise-01

echo create our configmap for wordpress
kubectl create -f wordpress-configmap.yaml

echo List created configmap
kubectl get configmap --namespace=exercise-01

echo Create our mariadb deployment
kubectl create -f mariadb-deployment.yaml

echo List pods from namespace
kubectl get pods --namespace=exercise-01

echo create our mariadb service
kubectl create -f mariadb-svc.yaml

echo List service
kubectl get svc --namespace=exercise-01

echo Create our wordpress deployment
kubectl create -f wordpress-deployment.yaml

echo List pods from namespace
kubectl get pods --namespace=exercise-01

echo create our wordpress service
kubectl create -f wordpress-svc.yaml

echo List service
kubectl get svc --namespace=exercise-01

echo Create our wordpress ingress
kubectl create -f ingress.yaml

echo List ingress
kubectl get ingress --namespace=exercise-01

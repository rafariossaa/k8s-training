#!/bin/bash
kubectl create -f ns.yaml
kubectl create -f mariadb-cm.yaml
kubectl create -f wordpress-cm.yaml
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f mariadb-deployment.yaml
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-canary-deployment.yaml
kubectl create -f wordpress-svc.yaml
kubectl create -f ingress.yaml

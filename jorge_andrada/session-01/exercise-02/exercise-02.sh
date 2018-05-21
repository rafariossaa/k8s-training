#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#
# ------------------------------------------------------------------
# [Jorge Andrada Prieto] [jandradap@gmail.com]
# Title: exercise-02.sh
# Description: Bitnami k8s training exercise-02
# ------------------------------------------------------------------
#

#debug
# set -x
# trap read debug

# Create namespace
kubectl create -f ns.yaml

# Create secrets
kubectl create -f secrets.yaml

# Create configMap
kubectl create -f cm.yaml

# Create services
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml

# Create deployments
kubectl create -f mariadb-deployment.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f wordpress-canary-deployment.yaml

# Create ingress
kubectl create -f ingress.yaml

sleep 60 # wait for services
export MY_SANDBOX_IP=$(kubectl cluster-info | grep "Kubernetes master" | awk -F "https://" '{print$2}' | awk -F ":" '{print$1}')
curl -I -k http://wordpress-exercise-02.com
curl -I -k https://wordpress-exercise-02.com
echo -e "\n\t URL: http://wordpress-exercise-02.com\n"

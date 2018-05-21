#!/bin/bash

kubectl create -f ns.yaml

kubectl create secret generic wordpress --namespace=exercise-03 --from-literal=userwp=julio_iglesias --from-literal=passwordwp=ylosabes \
--from-literal=rootpw=bitnami-training-2018 --from-literal=dbuser=k8s_training_user_02 --from-literal=dbpass=k8s_training_db_02 --from-literal=dbname=wordpressdb

kubectl create -f wordpress-cm.yaml
kubectl create -f wordpress-svc.yaml
kubectl create -f rds-svc.yaml
kubectl create -f wordpress-deployment.yaml
kubectl create -f ingress.yaml   
 

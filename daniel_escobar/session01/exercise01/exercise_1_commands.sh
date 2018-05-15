#!/bin/bash

kubectl create -f ns.yaml

kubectl create secret generic wordpress --namespace=exercise-01 --from-literal=userdb=wordpress_user --from-literal=passworddb=password_maria --from-literal=userwp=user --from-literal=passwordwp=bitnami \
--from-literal=rootpw=password_root --from-literal=dbuser=wordpress_user --from-literal=dbpass=password_maria --from-literal=dbname=wordpressdb --from-literal=dbcreate=wordpressdb

kubectl create secret generic mariadb --namespace=exercise-01 --from-literal=wpuser=wordpress_user --from-literal=wpdb=wordpressdb --from-literal=wppass=password_maria --from-literal=rootpw=password_root

kubectl create -f wordpress-cm.yaml

kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress-svc.yaml

kubectl create -f mariadb-deployment.yaml
kubectl create -f wordpress-deployment.yaml

kubectl create -f ingress.yaml   
 

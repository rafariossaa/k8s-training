# Exercise I

## WP + MariaDB

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-01* namespace.
* The WP site should use a MariaDB database.
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* WP should be accessible through http using a NGINX Ingress on the URL
*wordpress-exercise-01.com*.


## Basic and useful Commands

* Get all the k8 that are running
kubectl get all

* Get all pods running
kubectl get pods

* Delete all pods
kubectl delete pods --all

# K8s-training - Session 01 - Exercise 01

Bitnami kubernetes training session 01 - exercise 01

## Getting Started

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-01* namespace.
* The WP site should use a MariaDB database.
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* WP should be accessible through http using a NGINX Ingress on the URL
*wordpress-exercise-01.com*.

### Prerequisites

* Kubernetes cluster
* Kubectl cli

### Installing

Run the next command to setup the wordpress-mariadb environment in k8s.

Dont forget to add the cluster ip pointing to the domain wordpress-exercise-01.com to the /etc/hosts , you can do this with this single line command
```
echo "$CLUSTER_IP   wordpress-exercise-01.com" | sudo tee -a /etc/hosts
```
### Credentials

The credential used for wordpress and database is "admin/admin".

#### Create namespace
```
kubectl create -f namespace.yml
```

#### Launch mariadb stuff
```
kubectl create -f mariadb-secret.yml
kubectl create -f mariadb-configmap.yml
kubectl create -f mariadb-deployment.yml
kubectl create -f mariadb-service.yml
```

#### Launch wordpress stuff
```
kubectl create -f wordpress-secret.yml
kubectl create -f wordpress-deployment.yml
kubectl create -f wordpress-service.yml
kubectl create -f ingress.yml
```

#### Visit the WP cluster
http://wordpress-exercise-01.com 

#### Cleaning the k8s cluster
Run this command to remove all the resources created before.
```
for i in services deployment ingress secrets configMap;  do kubectl delete $i --all --namespace=exercise-01; done
```


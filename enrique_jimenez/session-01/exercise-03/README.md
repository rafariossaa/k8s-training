# K8s-training - Session 01 - Exercise 03

Bitnami kubernetes training session 01 - exercise 03

## Getting Started

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-03* namespace.
* The WP site should use a external RDS database already populated which details
are provided in the **Credentials** section.
* Use a service to connect WP wit the external database.
* Use ConfigMaps & Secrets to configure both MariaDB and WP
* Every container should have the proper readiness and liveness probes
configured
* WP should be accessible through http/https using a NGINX Ingress on the URL
*wordpress-exercise-03.com* . The ingress should handle the TLS certificates.
* WP admin panel should be accessible using a different URL, e.g.
http://wordpress-exercise-03.com/my-custom-admin/. Configure NGINX ingress to do that
redirection.

### Prerequisites

* Kubernetes cluster
* Kubectl cli

### Installing

follow the next steps to setup the wordpress-mariadb environment in k8s.

Dont forget to add the cluster ip pointing to the domain wordpress-exercise-0i3.com to the /etc/hosts , you can do this with this single line command
```
echo "$CLUSTER_IP   wordpress-exercise-03.com" | sudo tee -a /etc/hosts
```

### Credentials

The credentials used for wordpress and database are the next:

Database connection:
  * Hostname: kubernetes-training.cfxyxg2jnovx.us-east-1.rds.amazonaws.com
  * Name: k8s_training_db_14
  * User: k8s_training_user_14
  * Password: bitnami-training-2018

Wordpress:
  * User: julio_iglesias
  * Password: ylosabes


#### Create namespace
```
kubectl create -f namespace.yml
```

#### Launch database stuff
```
kubectl create -f database-secret.yml
kubectl create -f database-service.yml
```
#### TLS secret
```
kubectl create -f tls-secret.yml
```


#### Launch wordpress stuff
```
kubectl create -f wordpress-secret.yml
kubectl create -f wordpress-deployment.yml
kubectl create -f wordpress-service.yml
kubectl create -f ingress-redirect.yml
kubectl create -f ingress.yml
```


#### Visit the WP cluster
https://wordpress-exercise-03.com/my-custom-admin/ 

https://wordpress-exercise-03.com 

#### Cleaning the k8s cluster
Run this command to remove all the resources created above
```
for i in services deployment ingress secrets configMap;  do kubectl delete $i --all --namespace=exercise-03; done
```

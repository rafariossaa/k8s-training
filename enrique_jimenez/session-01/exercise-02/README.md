# K8s-training - Session 01 - Exercise 02

Bitnami kubernetes training session 01 - exercise 02

## Getting Started

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-02* namespace
* The WP site should use a MariaDB database
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* Every container should have the proper readiness and liveness probes
configured
* Use a canary deployment for WP. Consider the version 4.9.4 as the sable WP
version and use 4.9.5 in the canary deployment
* WP should be accessible through http using a NGINX Ingress on the URL
*wordpress-exercise-02.com*.

### Prerequisites

* Kubernetes cluster
* Kubectl cli

### Installing

follow the next steps to setup the wordpress-mariadb environment in k8s.

Dont forget to add the cluster ip pointing to the domain wordpress-exercise-02.com to the /etc/hosts , you can do this with this single line command
```
echo "$CLUSTER_IP   wordpress-exercise-02.com" | sudo tee -a /etc/hosts
```

### Credentials

The credential used for wordpress and database is "admin/admin".

#### Create namespace
```
kubectl create -f namespace.yml
```

#### Edit nginx-controler
```
kubectl edit deployment nginx-ingress-controller --namespace=kube-system
```
Add the image "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.10.2"


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

#### Add canary
```
kubectl create -f wordpress-deployment-canary.yml
```

#### Visit the WP cluster
http://wordpress-exercise-02.com 

#### Cleaning the k8s cluster
Run this command to remove all the resources created above
```
for i in services deployment ingress secrets configMap;  do kubectl delete $i --all --namespace=exercise-02; done
```




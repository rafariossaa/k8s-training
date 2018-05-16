# K8s-training - Session 02 - Exercise 02

Bitnami kubernetes training session 02 - exercise 02

## Getting Started

* Move MariaDB deployment to a StatefulSet
* Configures autoscale for the Nginx deployment. Make it optional in the chart.

### Prerequisites

* Kubernetes cluster
* Kubectl cli

### Tips

* For the HorizontalPodAutoscaler to work, all the containers have to define the resources they will request.

* Take into account that if your requests are too high, you may run out of capacity in the cluster.

### Installing
```
helm install lemp 
```
#### Cleaning the k8s cluster
```
helm delete lempname
```

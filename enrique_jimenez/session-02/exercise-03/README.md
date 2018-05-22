# K8s-training - Session 02 - Exercise 03

Bitnami kubernetes training session 02 - exercise 03

## Getting Started

* Add the postgresql chart as a dependency to the LEMP chart as an optional requirement.
* The postgresUser, postgresDatabase and postgresPassword variables from the dependency should not use the default value used in the postgres chart.

### Prerequisites

* Kubernetes cluster
* Kubectl cli

### Tips

* Use the stable/postgres chart from the official catalog: https://github.com/kubernetes/charts/tree/master/stable/postgresql

### Installing
```
helm install lemp 
```
#### Cleaning the k8s cluster
```
helm delete lempname
```

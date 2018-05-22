#!/bin/bash

# Delete namespaces

kubectl delete namespace exercise-01
kubectl delete namespace exercise-02
kubectl delete namespace exercise-03

# Create namespace
sleep 15
kubectl create namespace exercise-01

# Install LEMP chart
helm install lemp

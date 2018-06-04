#!/bin/bash

export KUBECONFIG=~/.kube/sandbox.conf
export MY_SANDBOX_IP=35.173.186.247

kubectl create ns session2
helm install --namespace=session2 --name=exercise01bis lemp
helm install --namespace=session2 --name=exercise01dep2 lemp --set app.host=myapp2.com --set mariadb.replicaCount=2 --set sampleapp.phpfpmimage.tag=7.0
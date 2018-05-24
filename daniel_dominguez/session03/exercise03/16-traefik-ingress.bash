#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: traefik
#
# At the end of this script you will have running Traefik
#

helm install --name my-traefik --namespace kube-system --set dashboard.auth.basic.username=k8straining,rbac.enabled=true,dashboard.enabled=true,dashboard.domain=dashboard.54.208.34.112.nip.io,ssl.enabled=true,serviceType=NodePort,service.nodePorts.https=443,service.nodePorts.http=80 stable/traefik

#!/bin/bash

# CHANGE NGINX image:

# STEP 1: Change to namespace kube-system
# kubectl config set-context $(kubectl config current-context) --namespace=kube-system

# STEP 2: Launch edit on nginx image
# kubectl edit deployment nginx-ingress-controller

# STEP 3: Search and replace container image to:
# quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.10.2

# STEP 4: Save file, and wait for ingress to be updated



context(){
	kubectl config set-context $(kubectl config current-context) --namespace=exercise-02
}
delete(){
	kubectl delete -f .
}
create(){
	kubectl create -f .
}
logCanary(){
	kubectl logs $(kubectl get pod -l tier=canary -o template --template="{{(index .items 0).metadata.name}}" )
}
logStable(){
	kubectl logs $(kubectl get pod -l tier=stable -o template --template="{{(index .items 0).metadata.name}}" )
}
dbSecret(){
  kubectl create secret generic mariadb-password --from-literal=password=DRM_DB_PASS --namespace=exercise-02
}

createNamespace(){
  kubectl create namespace exercise-02
}

dns(){
	echo "${SANDBOX_IP} wordpress-exercise-02.com" | sudo tee -a /etc/hosts
}

context
"$@"

# Set kubectl context to a target namespace
# ./commands.bash context

# Create db secret
# ./commands.bash dbSecret

# Delete current folder artifacts from context
# ./commands.bash delete

# Create current folder artifacts in context
# ./commands.bash create

# Log wordpress canary output
# ./commands.bash logCanary

# Log wordpress stable output
# ./commands.bash logCanary


# Add dns entry for this example
# ./commands.bash dns

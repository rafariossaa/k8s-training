#!/bin/bash

# CHANGE NGINX image:

# STEP 1: Change to namespace kube-system
# kubectl config set-context $(kubectl config current-context) --namespace=kube-system

# STEP 2: Launch edit on nginx image
# kubectl edit deployment nginx-ingress-controller

# STEP 3: Search and replace container image to:
# quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.10.2

# STEP 4: Save file, and wait for ingress to be updated

createCert(){
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt
}
wpSecret(){
  kubectl create secret generic wordpress-password --from-literal=password=**********
}
tlsSecret(){
  kubectl create secret generic tls-certificate --from-file=./tls.key --from-file=./tls.crt
}
dbSecret(){
  kubectl create secret generic mariadb-password --from-literal=password=bitnami-training-2018 --namespace=exercise-03
}

createNamespace(){
  kubectl create namespace exercise-03
}

context(){
	kubectl config set-context $(kubectl config current-context) --namespace=exercise-03
}
delete(){
	kubectl delete -f .
}
create(){
	kubectl create -f .
}
log(){
	kubectl logs $(kubectl get pod -l service=frontend -o template --template="{{(index .items 0).metadata.name}}" )
}
dns(){
	echo "${SANDBOX_IP} wordpress-exercise-03.com" | sudo tee -a /etc/hosts
}

context
"$@"

# Set kubectl context to a target namespace
# ./commands.bash context

# Delete current folder artifacts from context
# ./commands.bash delete

# Create current folder artifacts in context
# ./commands.bash create

# Log wordpress output
# ./commands.bash log

# Add dns entry for this example
# ./commands.bash dns

# Create db secret
# ./commands.bash dbSecret

# Create wp secret (for user password)
# ./commands.bash wpSecret

# Create tls certificate
# ./commands.bash createCert

# Create tls secret (for cert password)
# ./commands.bash tlsSecret

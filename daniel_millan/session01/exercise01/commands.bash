#!/bin/bash
context(){
	kubectl config set-context $(kubectl config current-context) --namespace=exercise-01
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
	echo "${SANDBOX_IP} wordpress-exercise-01.com" | sudo tee -a /etc/hosts
}
dbSecret(){
  kubectl create secret generic mariadb-password --from-literal=password=DRM_DB_PASS --namespace=exercise-01
}
createNamespace(){
  kubectl create namespace exercise-01
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

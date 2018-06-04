
# namespace creation ################
kubectl create namespace exercise-03

# set exercise-01 as default
kubectl config set-context kubernetes-admin@kubernetes --namespace=exercise-03


#Create svc for external mariadb
################################
kubectl apply -f mariadb-svc.yaml


# ConfigMap for wordpress env vars config
#########################################
kubectl apply -f wordpress-cm.yaml


# Create secret to configure password vars for wordpress
########################################################
kubectl create secret generic wordpress --from-literal=WORDPRESS_DATABASE_PASSWORD=pass --from-literal=WORDPRESS_PASSWORD=pass

#Create PVC for wordpress persistence (/bitname dir)
####################################################
kubectl apply -f wordpress-pvc.yaml

#Create svc for wordpress
#########################
kubectl apply -f wordpress-svc.yaml

#Create Deployment for wordpress
#No need securitycontext fsgroup as container executers as root
#################################################################################
kubectl apply -f wordpress-deployment.yaml

#Self signed x509 certificate generation
############################################
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=wordpress-03.35.171.157.107.nip.io"

# TLS secret creation
#####################
kubectl create secret tls wordpress-tls --key /tmp/tls.key --cert /tmp/tls.crt


#Create ingress for wordpress service (supports both http/https protocols) with my-custom-admin redirect
########################################################################################################
kubectl apply -f ingress-tls.yaml







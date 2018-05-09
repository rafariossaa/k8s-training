
# namespace creation
####################
kubectl create namespace exercise-01

# set exercise-01 namespace as default
######################################
kubectl config set-context kubernetes-admin@kubernetes --namespace=exercise-01

# ConfigMap for mariadb env variables
#####################################
kubectl apply -f mariadb-cm.yaml

# ConfigMap to map /bitnami/mariadb/conf/my_custom.cnf
######################################################
mariadb-my-custom-cnf.yaml

# Create secret to configure password vars for mariadb
######################################################
kubectl create secret generic mariadb --from-literal=MARIADB_ROOT_PASSWORD=pass --from-literal=MARIADB_PASSWORD=pass


#Create svc for mariadb
#######################
kubectl apply -f mariadb-svc.yaml


#Create local-storage class PVC for mariadb persistence (/bitname dir)
######################################################################
kubectl apply -f mariadb-pvc.yaml

#Create Deployment for mariadb
#As of 10.1.28-r2 version bitname image uses uid 1001 instead of root so securitycontext fsgroup is needed for PV usage
#######################################################################################################################
kubectl apply -f mariadb-deployment.yaml


# ConfigMap for wordpress env vars config
#########################################
kubectl apply -f wordpress-cm.yaml

# Create secret to configure password vars for wordpress
########################################################
kubectl create secret generic wordpress --from-literal=WORDPRESS_DATABASE_PASSWORD=k8straining --from-literal=WORDPRESS_PASSWORD=k8straining

#Create PVC for wordpress persistence (/bitname dir)
####################################################
kubectl apply -f wordpress-pvc.yaml

#Create Deployment for wordpress
#No need securitycontext fsgroup as container executes as root
##############################################################
kubectl apply -f wordpress-deployment.yaml

#Create svc for wordpress
#########################
kubectl apply -f wordpress-svc.yaml

#Create ingress for wordpress service
#####################################
kubectl apply -f ingress.yaml



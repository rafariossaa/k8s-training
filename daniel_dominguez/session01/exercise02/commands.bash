
# namespace creation ################
kubectl create namespace exercise-02

# set exercise-01 as default
kubectl config set-context kubernetes-admin@kubernetes --namespace=exercise-02

# ConfigMap for mariadb env vars config
#######################################
kubectl apply -f mariadb-cm.yaml

# ConfigMap for mariadb my_custom.cnf
#######################################
kubectl apply -f mariadb-my-custom-cnf.yaml

# Create secret to configure password vars for mariadb
######################################################
kubectl create secret generic mariadb --from-literal=MARIADB_ROOT_PASSWORD=k8straining --from-literal=MARIADB_PASSWORD=k8straining


#Create PVC for mariadb persistence (/bitname dir)
##################################################
kubectl apply -f mariadb-pvc.yaml

#Create Deployment for mariadb
#As of 10.1.28-r2 version bitname image uses uid 1001 instead of root so securitycontext fsgroup is needed for PV usage
########################################################################################################################
kubectl apply -f mariadb-deployment.yaml


#Create svc for mariadb
#######################
kubectl apply -f mariadb-svc.yaml



# ConfigMap for wordpress env vars config
#########################################
kubectl apply -f wordpress-cm.yaml

# Create secret to configure password vars for wordpress
########################################################
kubectl create secret generic wordpress --from-literal=WORDPRESS_DATABASE_PASSWORD=k8straining --from-literal=WORDPRESS_PASSWORD=k8straining

#Create PVC for wordpress persistence (/bitname dir)
####################################################
kubectl apply -f wordpress-pvc.yaml

#Create svc for wordpress
#########################
kubectl apply -f wordpress-svc.yaml

#Create Deployment for wordpress stable version 4.9.4
#No need securitycontext fsgroup as container executers as root
#################################################################################
kubectl apply -f wordpress-deployment.yaml

#Create Deployment for wordpress stable version 4.9.4 (testing canary deployment)
#No need securitycontext fsgroup as container executers as root
#################################################################################
kubectl apply -f wordpress-deployment-canary.yaml

#Create ingress for wordpress service
#####################################
kubectl apply -f ingress.yaml







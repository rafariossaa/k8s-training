
# namespace creation
####################
kubectl create namespace exercise-02

# set exercise-01 namespace as default
######################################
kubectl config set-context kubernetes-admin@kubernetes --namespace=exercise-02

# Create secret to configure password vars for mariadb
######################################################
kubectl create secret generic mariadb --from-literal=MARIADB_ROOT_PASSWORD=k8straining --from-literal=MARIADB_PASSWORD=k8straining

# Create secret to configure password vars for wordpress
########################################################
kubectl create secret generic wordpress --from-literal=WORDPRESS_DATABASE_PASSWORD=k8straining --from-literal=WORDPRESS_PASSWORD=k8straining

#Create api objects
#####################################
kubectl apply -f yaml/



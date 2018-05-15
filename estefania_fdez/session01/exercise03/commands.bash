#
# Advanced Kubernetes Training Exercise 03
# Estefanía Fernández Muñoz (estefafdez)
#
#########################################
# Configure Kubectl to use the K8s Sanbox
#########################################
## Download kubectl configuration via SFTP
export MY_SANDBOX_IP=X.X.X.X
sftp -i ~/.ssh/estefania_fdez.pem bitnami@${MY_SANDBOX_IP}
Connected to X.X.X.X
sftp> get /etc/kubernetes/admin.conf
Fetching /etc/kubernetes/admin.conf to admin.conf
/etc/kubernetes/admin.conf                                                                                                                        100% 5446    59.3KB/s   00:00
sftp> exit
## Adapt it and set it on your local env.
mv admin.conf ~/.kube/sandbox.conf
sed -i -e "s#server: https://.*:6443#server: https://${MY_SANDBOX_IP}:6443#g" ~/.kube/sandbox.conf
export KUBECONFIG=~/.kube/sandbox.conf
kubectl cluster-info

#####################
# Create namespaces
#####################
kubectl create ns exercise-03

###########
# Ingress
###########
kubectl create -f session01/exercise03/ingress.yaml
echo "${MY_SANDBOX_IP} wordpress-exercise03.com" | sudo tee -a /etc/hosts

##################################################
# Create Secrets and ConfigMap
##################################################
# ConfigMap
kubectl create -f session01/exercise03/cm.yaml
# Secrets
kubectl create -f session01/exercise03/wordpress-secrets.yaml

##################################################
# Deployments and Services for Wordpress
##################################################
# Deployment
kubectl create -f session01/exercise03/wordpress-deployment.yaml
# Service
kubectl create -f session01/exercise03/wordpress-svc.yaml
# Ingress
kubectl create -f session01/exercise03/wordpress-ingress.yaml

##################################################
# Add Canary deployment
##################################################
kubectl create -f session01/exercise03/wordpress-canary-deployment.yaml

##################################################
# Visit the Wordpress Site
##################################################
http://wordpress-exercise03.com

##################################################
# NOTE
##################################################
#The redirect is not finished yet.

#
# Advanced Kubernetes Training Session 02 - Exercise 01
# Estefanía Fernández Muñoz (estefafdez)
#

#########################################
# Create Lemp
#########################################
helm create lemp

#########################################
# Set cluster config
#########################################
kubectl config set-cluster exercise01

#########################################
# Execute Helm
#########################################
helm install lemp

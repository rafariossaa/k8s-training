#
# Advanced Kubernetes Training Session 02 - Exercise 03
# Estefanía Fernández Muñoz (estefafdez)
#
#########################################
# Set cluster config
#########################################
kubectl config set-cluster exercise01

# Use context exercise-01 with the namespace: exercise01
kubectl config use-context exercise-01

#Execute helm
helm install lemp

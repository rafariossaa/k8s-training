# 
# EXERCISE 1
#

1. First, we have created the namespace exercise-01:
kubectl create ns exercise-01

2. We need a secret to store credentials to connect to mariadb:
kubectl create -f mariadb-secret.yaml

3. Then, we have to create the deployment:
kubectl create -f mariadb-deployment.yaml
4. The deployment is exposed wioth type CLUSTERIP because is the backend.
kubectl expose deployment/mariadb --port=3306 -n exercise-01

4. Later, we create wordpress deployment and expose it as a service
kubectl create -f wordpress-deployment.yaml
kubectl expose deployment/wordpress --port=80 --type=NodePort -n exercise-01

5. In this point, we have to map wordpress-exercise-01.com with EC2 instance ip in hosts file.
34.227.116.240  wordpress-exercise-01.com

6. Finally, we have to create the ingress
kubectl create -f ingress.yaml

7. We can test the service is up and running
http://wordpress-exercise-01.com
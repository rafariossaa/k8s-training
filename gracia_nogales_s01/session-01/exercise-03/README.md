# 
# EXERCISE 3
#

1. First, we have created the namespace exercise-03:
kubectl create ns exercise-03

2. We need a secret to store credentials to connect to external mariadb:
kubectl create -f mariadb-secret.yaml

3. Then, we have to create the service and endpoint:
kubectl create -f svc-mariadb.yaml

4. We haver to create a secret to store config and credentials to connect to wordpress
kubectl create -f wordpress-secret.yaml

4. Later, we create wordpress deployment and expose it as a service
kubectl create -f wordpress-deployment.yaml
kubectl expose deployment/wordpress --port=80 --type=NodePort -n exercise-03

5. We can scale the deployment to keep 2 replicas
kubectl scale --replicas=2 deployment/wordpress -n exercise-03

6. In this point, we have to map wordpress-exercise-03.com with EC2 instance ip in hosts file.
34.227.116.240  wordpress-exercise-03.com

7. We need to create a certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=wordpress-exercise-03.com"

8. In this moment, we have to create a tls secret to store the certificate
kubectl create secret tls tls-secret --key tls.key --cert tls.crt

6. Finally, we have to create the ingress
kubectl create -f ingress.yaml

7. We can test the service is up and running
wget http://wordpress-exercise-03.com



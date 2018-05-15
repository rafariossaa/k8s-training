# 
# EXERCISE 2
#

1. First, we have created the namespace exercise-02:
kubectl create ns exercise-02

2. We need a secret to store credentials to connect to mariadb:
kubectl create -f mariadb-secret.yaml

3. Then, we have to create the deployment:
kubectl create -f mariadb-deployment.yaml
4. The deployment is exposed with type CLUSTERIP because is the backend.
kubectl expose deployment/mariadb --port=3306 -n exercise-02

4. Later, we create wordpress deployment and expose it as a service
kubectl create -f wordpress-deployment.yaml
kubectl expose deployment/wordpress --port=80 --type=NodePort -n exercise-02

5. We can scale the deployment to keep 2 replicas
kubectl scale --replicas=2 deployment/wordpress -n exercise-02

6. In this point, we have to map wordpress-exercise-02.com with EC2 instance ip in hosts file.
34.227.116.240  wordpress-exercise-02.com

6. In this moment, we have to create the ingress
kubectl create -f ingress.yaml

7. We can test the service is up and running
wget http://wordpress-exercise-02.com

8. To test the cannary deployment we have to apply stable version and later the new version. We can test that two deployments coexist at the same time.
kubectl apply -f wordpress-deployment.yaml
kubectl apply -f wordpress-canary-deployment.yaml


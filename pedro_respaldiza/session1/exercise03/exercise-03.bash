# Exercise 3 of session 1: Mariadb deployment
# Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
# K8s Training user: pedro_respaldiza

# Exit if an error occur
set -e

# Generate TSL certificate
openssl req -newkey rsa:2048 -nodes -keyout wordpress-exercise-03.key -x509 -days 365 -out wordpress-exercise-03.crt -subj "/CN=wordpress-exercise-03.com"

# Create namespace
kubectl create -f exercise-03-ns.yaml

# Create secrets
kubectl create secret generic mariadb-secret  --namespace=exercise-03 --from-literal=dbuser=k8s_training_user_07 --from-literal=dbname=k8s_training_db_07 --from-literal=dbpassword=bitnami-training-2018 -o yaml --dry-run > mariadb-secret.yaml

kubectl create secret generic wordpress-secret --namespace=exercise-03 --from-literal=wppassword=ylosabes -o yaml --dry-run > wordpress-secret.yaml
kubectl create secret tls ingress-secret --namespace=exercise-03 --key wordpress-exercise-03.key --cert wordpress-exercise-03.crt -o yaml --dry-run > ingress-secret.yaml
kubectl create -f mariadb-secret.yaml
kubectl create -f wordpress-secret.yaml
kubectl create -f ingress-secret.yaml

# Create ConfigMap
kubectl create configmap wordpress-cm --namespace=exercise-03 --from-literal=wpuser=julio_iglesias --from-literal=wpname="La vida sigue igual" -o yaml --dry-run > wordpress-cm.yaml
kubectl create -f wordpress-cm.yaml

# Create services and deployment
kubectl create -f mariadb-svc.yaml
kubectl create -f wordpress.yaml

# Create Ingress rule
kubectl create -f wordpress-ingress.yaml

# Add the host name in the /etc/hosts file (the environment variable MY_SANDBOX_IP was added to the .bashrc of my system) 
echo "${MY_SANDBOX_IP}   wordpress-exercise-03.com" | sudo tee -a /etc/hosts

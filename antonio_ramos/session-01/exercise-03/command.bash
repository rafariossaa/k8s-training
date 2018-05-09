echo Create our namespace
kubectl create ns exercise-03
echo List namespace to check it is created
kubectl get ns
echo Create our secret for mariadb 
kubectl create -f mariadb-secret.yaml
echo Create our secret for wordpress 
kubectl create -f wordpress-secret.yaml
#echo create our key and crt for wordpress-exercise-03.com
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=wordpress-exercise-03.com"
echo create our tls secret
kubectl create -f tls.yaml
echo List created secret
kubectl get secret --namespace=exercise-03
echo create our configmap for wordpress
kubectl create -f wordpress-configmap.yaml
echo List created configmap
kubectl get configmap --namespace=exercise-03
echo create our mariadb rds service
kubectl create -f rds-svc.yaml
echo List service
kubectl get svc --namespace=exercise-03
echo Create our wordpress deployment
kubectl create -f wordpress-deployment.yaml
echo List pods from namespace
kubectl get pods --namespace=exercise-03
echo create our wordpress service
kubectl create -f wordpress-svc.yaml
echo List service
kubectl get svc --namespace=exercise-03
echo create our wordpress ingress
kubectl create -f ingress.yaml
echo create our wordpress rewrite ingress
kubectl create -f ingress-admin.yaml
echo List our ingress
kubectl get ingress -namespace=exercise-03





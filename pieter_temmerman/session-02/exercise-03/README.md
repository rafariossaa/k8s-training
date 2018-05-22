# README
## Kubernetes Exercise-03

### Introduction

The present exercise deploys a NGINX container with PHP-FPM
To set it up, we rely on several Kubernetes objects such as:

- Secrets
- ConfigMaps
- Deployments (and ReplicaSets)
- Services
- StatefulSet
- HorizontalPodAutoscaler

### How to deploy

Execute 'helm install lemp'

Note: It is expected that your kubectl environment is configured correctly.
That is, it should be pointing to the correct Kubernetes API IP and use the X509 certificates to authenticate against it.

### Customize deployment

You can customize the lemp environment by modifying the values.yaml file as desired.
Optionally, you can enable or disable postgres to be installed and override it's properties with the following command:

'''
helm install lemp --set postgresql.enabled=true,postgresql.postgresUser=pg_username,postgresql.postgresPassword=pg_password,postgresql.postgresDatabase=pg_database
'''

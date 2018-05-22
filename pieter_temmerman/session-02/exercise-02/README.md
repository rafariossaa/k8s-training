# README
## Kubernetes Exercise-02

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

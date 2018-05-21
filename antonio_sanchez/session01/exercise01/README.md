# Exercise01 - Basic Wordpress Deployment

## Intro

This is the first exercise for the k8s Bitnami Training. This exercise consist only in the deployment of Wordpress and MariaDB backend.

## Structure

All the objects has been included in files, according to the Kubernetes good practices. For the frontend and the backend side exists differentes files representing the differents objects, like:

* **cm** (ConfigMap)
* **deployment** (Deployments)
* **secret** (Secrets)
* **svc** (Service)

In addition to this, exists the **ns** file with the Namespace and the **ingress** file to create de Ingress controller for the stack.

## Deployment

For the deployment, you only need to execute the **commands.bash** script included in the root of folder exercise project.

```bash
# ./commands.bash
```

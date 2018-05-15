# Exercise03

## Intro

The third exercise for K8s Bitnami Training includes:

* Connect the stack to external database (AuroraDB in AWS)
* Generate TLS certs in Ingress and redirect my-custom-admin -> wp-admin

## Structure

This exercise is based in exercise01. Some modification are included to accomplish the exercise.

First of all, we need to generate certs with the objetive to include in Ingress Service. The first is create certs:

```bash
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=wordpress-exercise-03.com"
```

Next is generate the Secret Object:

```bash
# kubectl create secret tls tls-wp --key /tmp/tls.key --cert /tmp/tls.crt --namespace=exercise03
```

This commands are included in **commands.bash** script.


## Deployment

For the deployment, you only need to execute the **commands.bash** script included in the root of folder exercise project.

```bash
# ./commands.bash
```

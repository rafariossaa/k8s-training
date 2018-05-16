# Exercise I

## LEMP chart

We will create a chart with:

- Use deployments to create Nginx and MariaDB
- Add persistence to pods
- Use initContainers to download a php application from a git repository.
- Use configMaps mounted as a volume for the Nginx configuration.
- Sensitive data must use Secrets.

We will use exercise-01 context with namespace exercise-01 

```
kubectl config use-context exercise-01
```

All is done with helm, execute:

```
helm install lemp
```

You must modify your /etc/hosts and add session02-exercise-01.com entry with ip from your kubectl cluster-info


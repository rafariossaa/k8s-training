# Exercise II

## LEMP chart improvement

We will improve our chart with:

- Use statefulset with MariaDB
- Add autoscale for Nginx deployment and do optional


We will use exercise-02 context with namespace exercise-02 

```
kubectl config use-context exercise-02
```

All is done with helm, execute:

```
helm install lemp
```



You must modify your /etc/hosts and add session02-exercise-02.com entry with ip from your kubectl cluster-info


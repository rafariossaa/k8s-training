# Exercise III

## LEMP add postgresql chart as dependency

We will improve our chart with:

- Add an optional dependency from postgresql chart with custom user and password


We will use exercise-03 context with namespace exercise-03

```
kubectl config use-context exercise-03
```

All is done with helm, first we need update dependence to download postgresql chart, execute:

```
helm dep up lemp
```

then as usual, execute:

```
helm install lemp
```



You must modify your /etc/hosts and add session02-exercise-03.com entry with ip from your kubectl cluster-info


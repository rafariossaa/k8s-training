# Exercise III

## WP with external database

We will create a frontend for wordpress with tls and rewrite /mycustom-admin/ to /wp-admin and the backend will be an external rds database in namespace exercise-03. Delete name space first to asure it is not createt yet:

```
kubectl delete ns exercise-03
```

All is done in command.bash, execute:

```
./command.bash
```

You must modify your /etc/hosts and add wordpress-exercise-03.com entry with ip from kubectl cluster-info

You must modify rds-svc.yaml with a valid rds server name and populate with valid credentials mariadb-secret.yaml


Wait until all pods are ready:

```
kubectl get pods --namespace=exercise-03 --watch
NAME                                    READY     STATUS    RESTARTS   AGE
wordpress-deployment-6b59fb9b8c-rbpz2   1/1       Running   0          1m

```



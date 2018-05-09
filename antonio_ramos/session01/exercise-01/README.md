# Exercise I

## WP + MariaDB

We will create a basic wordpress frontend with mariadb backend in namespace exercise-01. Delete name space first to asure it is not createt yet:

```
kubectl delete ns exercise-01
```

All is done in command.bash, execute:

```
./command.bash
```

You must modify your /etc/hosts and add wordpress-exercise-01-com entry with ip from kubectl cluster-info


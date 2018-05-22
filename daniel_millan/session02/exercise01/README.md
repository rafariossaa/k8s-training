## Exercise I: Create a LEMP chart
- Use deployments to create Nginx and MariaDB
- Add persistence to pods
- Use initContainers to download this php application from a git repository.
- Use configMaps mounted as a volume for the Nginx configuration.
- Sensitive data must use Secrets.

### Useful link:
bitnami/nginx image readme
bitnami/php-fpm image readme
bitnami/mariadb image readme


# What I did

#### Create lemp chart

```
helm create lemp
```

####  Add MariaDB deployment

Create mariadb.yaml file under lemp/templates

Create secret.yaml file under lemp/templates

Add secrets to secret.yaml (mariaRootPassword and mariaUserPassword)

Add config variables to values.yaml which resolve root and user password for mariadb

Modify mariadb.yaml so it gets MARIADB_ROOT_PASSWORD, MARIADB_USER, 
MARIADB_PASSWORD values from secrets

####  Download php app

Create under deployment.yaml a new busybox initContainer for downloading the php file via wget and store in a hostPath volume

####  Add Persistence to pods

Create cm.yaml to store nginx configuration

Provide volume under deployment.yaml to it resolves to configmap, use volumeMount on both nginx and php-fpm containers

Mount app volume to both containers

##### Commands
```
# Clean everything for this chart
helm delete --purge exercise01

# Install lemp chart
helm install lemp -n exercise01
```




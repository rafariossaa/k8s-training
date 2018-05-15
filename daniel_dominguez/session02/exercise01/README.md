# K8S-training. Session 02 - Exercise 01.

The aim of this exercise is to create a LEMP chart with the following characteristics:

- Use deployments to create Nginx and MariaDB
- Add persistence to pods
- Use initContainers to download a php application from a git repository.
- Use configMaps mounted as a volume for the Nginx configuration.
- Sensitive data must use Secrets.

## How to install this chart

Execute:
# helm install lemp/

## Most relevant aspects
You can use the following options to override default values:
ingress.enabled -> Enable or disable ingress creation
ingress.host[0] -> URL hostname 
resources={} -> to disable cpu requests
resources.requests.cpu -> to set cpu requests
mariadb.mariadbDatabase -> database name
mariadb.mariadbUser -> database user
mariadb.dbPassword -> database user password
mariadb.rootPassword -> database root password

See values.yaml for additional customizing 

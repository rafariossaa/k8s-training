Exercise 1 of session 1: Mariadb deployment
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
K8s Training user: pedro_respaldiza
---
# Create a WordPress with a MariaDB
As requested by the exercise I created a namespace, the services and deployments to generate a Worpdress and its database.
I have created the services and deployments in a single multi-yaml file. This works for me because I use [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors) and is easier for me edit namespaces, ports, etc.. at same time. If there is any reason that discourages its use, tell me to stop using them.

## Bash script
The bash script launches everything necessary sequentially:
- namespace> to host all the elements
- secrets & configMaps> to have the environment variables available
- mariaDB database> service + deployment
- WordPress> service + deployment
- Ingress
- Add the host name to check the ingress configuration.

## Enviroment Variables
### ConfigMap
The Wordpress environment variables that I have not considered sensitive and therefore are in the in configMap are:
- WORDPRESS_BLOG_NAME
- WORDPRESS_USERNAME
### Secrets
The environment variables that I have decided are useful and are sensitive to be in secrets are:
- WORDPRESS_DATABASE_USER
- WORDPRESS_DATABASE_PASSWORD
- WORDPRESS_DATABASE__NAME
- WORDPRESS_PASSWORD
- MARIADB_ROOT_PASSWORD

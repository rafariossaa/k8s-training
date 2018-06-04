# Exercise I: Create a LEMP chart

- Use deployments to create Nginx and MariaDB
- Add persistence to pods
- Use initContainers to download this php application from a git repository.
- Use configMaps mounted as a volume for the Nginx configuration.
- Sensitive data must use Secrets.
- Useful link:
    - bitnami/nginx image readme
    - bitnami/php-fpm image readme • bitnami/mariadb image readme

# Tips:

- helm create lemp for generating the chart basic structure
- The deployment for nginx and php should use the following containers:
- initContainer to download the php app from https://github.com/bitnami-labs/k8s-training-resources. You can use the alpine/git docker image or whichever docker image with git.
- nginx container (bitnami/nginx)
- php-fpm container (bitnami/php-fpm)
- Both nginx and php-fpm containers should mount the application in the same path.
- The nginx configuration to serve php code through php-fpm container is here.
- Remember to update the MOUNT_PATH placeholder before mounting the configuration in the nginx container using a configMap.
- You should mount the nginx configuration file at /bitnami/nginx/conf/vhosts/myapp.conf in the nginx container.

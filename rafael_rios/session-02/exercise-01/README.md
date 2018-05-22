# Exercise I

## LEMP Chart

- Use deployments to create nginx and mariadb
- Add persistence to pods
- Use initcontainers to download from a git repository https://github.com/bitnami-labs/k8s-training-resources
- Use configMaps mounted as a volume for the nginx configuration
- Sensitive data must use Secrets
- useful link:
  - https://github.com/bitnami/bitnami-docker-nginx
  - https://github.com/bitnami/bitnami-docker-php-fpm
  - https://github.com/bitnami/bitnami-docker-mariadb

### Tips
- The nginx configuration to serve php code through php-fpm container is here: https://github.com/bitnami-labs/k8s-training-resources/blob/master/php-sample-app/vhosts/myapp.conf

- Both nginx and php-fpm container should moun the application in the same path


### Notes


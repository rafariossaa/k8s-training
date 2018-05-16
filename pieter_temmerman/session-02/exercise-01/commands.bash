#!/bin/bash

# Delete namespaces

kubectl delete namespace exercise-01
kubectl delete namespace exercise-02
kubectl delete namespace exercise-03

# Create namespace
sleep 6
kubectl create namespace exercise-01

# Create Nginx config
# First of all, create a simple nginx config file, and store it in a config map

cat <<'EOF' > my_vhost.conf
server {
  listen 0.0.0.0:8080;
  server_name myapp.com;

  root /data/php-sample-app;

  location / {
    try_files $uri $uri/index.php;
  }

  location ~ \.php$ {
    # As php and nginx are in the same pod, we can access php-fpm service through localhost
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    include fastcgi.conf;
  }
}
EOF

kubectl -n exercise-01 create configmap nginx-config --from-file=my_vhost.conf

# Install LEMP chart
helm install lemp

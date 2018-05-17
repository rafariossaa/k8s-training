Exercise 1 of session 2: Create a LEMP chart
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza) 
K8s Training user: pedro_respaldiza
---

# Create a LEMP chart
In the deployment of the application I have placed a Nginx container to serve the application and  a PHP-fpm container as a sidecar. The application, as we will see later, will be downloaded from github I have not seen necessary that there has persistence, so the volume that I will use is emtyDir. Presumably, any interesting data will be stored in the database, which will have persistence.

## git
To download the application from github I used an initContainer with an image that supports git. I have forced the return to a previous commit because in this point the application was already complete and thus I do not have the vhost configuration visible in my web server.

## VHOST
The configuration of the vhost is available in a configMap functioning as a volume.

## Mariadb

The database has its own service, its environment variables defined in secrets and its own persistence volume.


I have a problem that makes it not work properly. I can not identify it. I hope to find it.
---

# Corrections

~~~
pedro_respaldiza/session2/exercise01/lemp/templates/vhost.yaml
+      listen 0.0.0.0:8080;
+      server_name myapp.com;
+
+      root /MOUNT_PATH/php-sample-app;
 @tompizmor
tompizmor 3 hours ago
MOUNT_PATH was a placeholder, you need to update it to the actual mount path in your nginx and php containers
~~~
This is the origin of all my problems. I assumed Vhost as correct and I reviewed everything hundreds of times less that. I'm a bit embarrassed, it was very obvious and you could not guess my route. Obviously I fix it.
---
~~~
pedro_respaldiza/session2/exercise01/lemp/templates/vhost.yaml
+      }
+
+      location ~ \.php$ {
+        fastcgi_pass 127.0.0.1:9000;
 @tompizmor
tompizmor 3 hours ago
what if php is not running in the port 9000?
~~~
At first I did not understand the question. Then I checked and I saw that the port of the php container was not indicated in the deployment of the second exercise. Fix and check the other two to avoid problems.
---
~~~
pedro_respaldiza/session2/exercise01/lemp/values.yaml
+  storange: 10Gi
+
+secretsmariadb:
+  dbname: bm9tYnJlCg==
 @tompizmor
tompizmor 3 hours ago
you could add the plaintext here and then encode in base64 in the secret with a go template function.
~~~
Not only is it a better implementation, in addition it is a good excuse to check the go templates functions. I start working on it.
---


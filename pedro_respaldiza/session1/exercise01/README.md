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
- WORDPRESS_TABLE_PREFIX
    I have considered this variable of interest because if eventually someone gets access to the database, it is more difficult to identify our application. It is not the best security measure but if it is available I think it is better to use it.


## Corrections
---
~~~
pedro_respaldiza/session1/exercise01/README.md
+---
+# Create a WordPress with a MariaDB
+I have created the services and deployments in a single multi-yaml file. This works for me because I use [vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors) and is easier for me edit namespaces, ports, etc.. at same time. If there is any reason that discourages its use, tell me to stop using them.
 @juan131
juan131 3 hours ago
Totally valid! Feel free to use the solutions you're more familiar with
~~~
I have not found any inconvenience but I indicated it in case you know any. Anyway, thanks for the clarification.
---
~~~
pedro_respaldiza/session1/exercise01/mariadb.yaml
+    spec:
+      containers:
+        - name: wordpress
+          image: bitnami/mariadb:10.1
 @juan131
juan131 3 hours ago
Why did you use this specific version instead of latest? (just asking)
~~~
I have no reason. Simply look for a functional image and use it. I will correct it in all the exercises without indicating it again. Use the latest versions (both WordPress and MariaDB) is a better implementation.
~~~
I would choose a different name for the container since it's running a MariaDB image
~~~
In the beginning the name was to correlate it with the application. But that function is already covered by the namespace. So, it's true i have to change the pod name.
---
~~~
pedro_respaldiza/session1/exercise01/README.md
+- WORDPRESS_BLOG_NAME
+- WORDPRESS_USERNAME
+### Secrets
+The environment variables that I have decided are useful and are sensitive to be in secrets are:
 @juan131
juan131 3 hours ago
I think there are others not listed here such as WORDPRESS_TABLE_PREFIX
~~~
Yes, I added them during a review and forgot to add them. I update the README
---
~~~
pedro_respaldiza/session1/exercise01/wordpress-ingress.yaml
+    app: wordpress
+    type: frontend
+  annotations:
+    nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
 @juan131
juan131 3 hours ago
Why do you need to enable this redirection?
~~~
No, it is not necessary. I remove it in all the exercises.
---
~~~
pedro_respaldiza/session1/exercise01/wordpress.yaml
+  - name: https-sv-port
+    port: 443
+    targetPort: https-port
+  type: NodePort
 @juan131
juan131 7 hours ago
You don't need to use NodePort since you're accessing your WP site through NGINX Ingress.
~~~
It is true. This is the magic of Ingress. I modify it in all the exercises.
---
~~~
pedro_respaldiza/session1/exercise01/mariadb.yaml
+                secretKeyRef:
+                  name: mariadb-secret
+                  key: dbrootpassword
+            - name: WORDPRESS_TABLE_PREFIX
 @juan131
juan131 7 hours ago
MariaDB image does not take into account this env. variable

See: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/10.1/rootfs/mariadb-inputs.json

It has no effect here
~~~
Not only does it have no effect, it does not make sense. That variable corresponds to WordPress, it is indicated in the wp-config.php. The change of site, in exercises 01 and 02, so that has effect.
---

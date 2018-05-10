Exercise 2 of session 1: Mariadb deployment
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
K8s Training user: pedro_respaldiza
---
# Exercise II: WordPress Improvements
I used the files from the previous exercise as a basis.
In wordpress.yaml I have indicated the corresponding image, I have indicated that it is stable and I have added a new canary deployment. I have deployed three copies of the stable version and one of the canary version.

As indicated, I changed the ingress image to be able to use
~~~
nginx.ingress.kubernetes.io/affinity: cookie
~~~
This forces a user who visits one of the versions to have a persistent session based on cookies.

## Liveness and Readiness
I used the same command in the liveness and readiness test, but the initial dealy of the readiness test is shorter to prevent the containers from restarting unnecessarily until the deployment is finished.

## Bash Script
The bash script launches all elements. The sequence and the commands are the same as in exercise-01 because all the modifications have been made in the deployment files.

## Correnctions
---
~~~
pedro_respaldiza/session1/exercise02/mariadb.yaml
+                  name: mariadb-secret
+                  key: dbprefix
+          readinessProbe:
+            exec:
 @juan131
juan131 7 hours ago
Not sure if it's the best way to test if MariaB is ready but it's a valid solution. Here you have an alternative:

          exec:
            command:
            - mysqladmin
            - ping
~~~
Not only is it an alternative, your version gives real meaning to the tests. I implement it for Liveness and Readiness. My test would allow to continue running and send traffict to a pod with a failure in the service.
~~~
pedro_respaldiza/session1/exercise02/wordpress-ingress.yaml
+    type: frontend
+  annotations:
+    nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
+    nginx.ingress.kubernetes.io/affinity: cookie
 @juan131
juan131 7 hours ago
Does it work? This annotation needs others complement annotations:

nginx.ingress.kubernetes.io/session-cookie-name
nginx.ingress.kubernetes.io/session-cookie-hash
~~~
It is true, I change it.:w
~~~
pedro_respaldiza/session1/exercise02/wordpress.yaml
+                  key: wpuser
+          readinessProbe:
+            exec:
+              command:
 @juan131
juan131 8 hours ago
Again.. I don't thinks it's a good way to test WP readiness.. Here you have an alternative:

        readinessProbe:
          initialDelaySeconds: 30
          httpGet:
            path: /wp-login.php
            port: http
~~~
It is the same case of MariaDB tests. Your tests are much better and I implement them.
---


Exercise 3 of session 1: Mariadb deployment
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
K8s Training user: pedro_respaldiza
---
# Exercise III: WordPress with external Database
To connect WordPress with an external database, I used an externalName type service.
The deployment of mariaDB is no longer necessary.

## Secure WP
To hide wp-admin I used the ingress anotation:
~~~
nginx.ingress.kubernetes.io/configuration-snnipet:
~~~
with the code:
~~~
      location ^~ /k8sadmin {return 301 http://wordpress-exercise-03.com/wp-login.php;}
      location ^~ /wp-admin {return 301 http://wordpress-exercise-03.com/404;}
~~~
I have been looking for other options but I have not make them work.
I haved special interest to:
~~~
nginx.ingress.kubernetes.io/proxy-redirect-from: 
nginx.ingress.kubernetes.io/proxy-redirect-to:
~~~

## Could the Ingress handle my TLS certificates?
Yes, it can do it.
The deployment of my application includes the management of the certificate by Ingress.
Being a self-signed certificate only serves as proof of concept but I think it is equally valid.

## Bash Script

This bash script performs all the necessary steps for the deployment of the entire infrastructure:

- Generation of the self-signed certificate
- Creation of the namesace
- Creation of secrets > In this exercise I have added ingress-secret.yaml for the management of the certificate. The rest of the environment variables correspond to those provided
- Creation of ConfigMaps
- Creation of services and deployment > In the case of mariadb we only need the service to connect to the external database. For Wordpress we need to create the service and the deployment (which are in the same file)
- Creation of Ingress rules
- Add the host name to / etc / hosts to test the correct functioning of ingress.

## Corrections
---
~~~
pedro_respaldiza/session1/exercise03/wordpress-exercise-03.key
@@ -0,0 +1,28 @@
+-----BEGIN PRIVATE KEY-----
 @juan131
juan131 8 hours ago
Please remove this from the PR

 @pedrorespaldiza	Reply…
pedro_respaldiza/session1/exercise03/wordpress-exercise-03.crt
@@ -0,0 +1,17 @@
+-----BEGIN CERTIFICATE-----
 @juan131
juan131 8 hours ago
Please remove this from PR
~~~
Removed and added to gitignore
---
~~~
pedro_respaldiza/session1/exercise03/wordpress-ingress.yaml
+    nginx.ingress.kubernetes.io/from-to-www-redirect: "true"
+    nginx.ingress.kubernetes.io/configuration-snippet: |
+      location ^~ /k8sadmin {return 301 http://wordpress-exercise-03.com/wp-login.php;}
+      location ^~ /wp-admin {return 301 http://wordpress-exercise-03.com/404;}
 @juan131
juan131 8 hours ago  • 
Unless you configure WP to use a different Admin URI this will break the functionality.. It is unnecessary the 404, but it's ok
~~~
I believe that wp-login.php is perfectly functional. If I do not rewrite wp-admin to 404 I will only be creating an alternate route without affecting wp-admin. Do you mean another functionality? If you want we can look it tomorrow.
---

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

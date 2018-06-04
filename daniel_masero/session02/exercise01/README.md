

To be able to install and run the command:
 helm install exercise01/

When we install it, we deploy two applications:
• The first one contains a container with nginx and another one with php-fpm that serve an application previously downloaded from a 
  github repository
• The second one contains a mariaDB database with local presence. 

You can configure both the directory where the database persistence will be performed and the repository.
of github among many others. See values.yaml


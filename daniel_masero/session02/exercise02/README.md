

To be able to install and run the command:

 helm install exercise02/

When we install it, we deploy two applications:
• The first one contains a container with nginx and another one with php-fpm that serve an application previously downloaded from a 
  github repository
• The second one contains a mariaDB database with local presence. 

You can configure both the directory where the database persistence will be performed and the repository.
of github among many others. See values.yaml

In addition the deployement of mariaDB has been changed to be a StatefulSet one which has persistent storage linked to 
every node

Also a self-scaling scroll for the first application has been added, this is selectable by helm when installing it.

Due to being a Stateful it is necessary to execute the command:

	kubectl delete persistentvolumeclaim name_persistentvolumeclaim_automatically_generated

after deleting the installation
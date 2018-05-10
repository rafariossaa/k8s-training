# Exercise I

## WP + MariaDB

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-01* namespace.
* The WP site should use a MariaDB database.
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* WP should be accessible through http using a NGINX Ingress on the URL
*wordpress-exercise-01.com*.

### What I did

- try to manage how to deal with the general configuration of Pods, read some docs here and there and review the session presentation

- create namespace 
```kubectl create namespace exercise01```

- change current context to namespace exercise01 so I don't mess with other namespaces
```./commands.bash context```

- create secrets for mariadb-root, mariadb-user and wp-user
```./commands.bash dbSecret```

- write the config map yaml

- write the deployments yaml for wp and mariadb, had to do some google searchs since this is the first time I had to handle with a non-example deployment definition

- write the services yaml for wp and mariadb

- write the ingress part

- launch all artifacts
```./commands.bash create```

- To delete artifacts created via docker create -f, I added a script command to delete everything created via yaml files.
```./commands.bash delete```

- add DNS entry
```./addDNS.bash dns```

- Load browser and point to http://wordpress-exercise-01.com/

### Problems found

- Editors do not handle yaml as good as they should, better use Visual Studio Code, or TextMate and change tabs for 2 spaces
- Selectors problems, require a double check, lost one complete day checking why wp did not connect to mariadb but mysql cli did.


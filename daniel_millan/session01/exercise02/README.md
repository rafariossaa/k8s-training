# Exercise II

## WP Improvements

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-02* namespace
* The WP site should use a MariaDB database
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* Every container should have the proper readiness and liveness probes
configured
* Use a canary deployment for WP. Consider the version 4.9.4 as the sable WP
version and use 4.9.5 in the canary deployment
* WP should be accessible through http using a NGINX Ingress on the URL
*wordpress-exercise-02.com*.

### What I did

- create namespace 
```kubectl create namespace exercise02```

- change current context to namespace exercise02 so I don't mess with other namespaces
```./commands.bash context```

- create secrets for mariadb-root, mariadb-user and wp-user
```./commands.bash dbSecret```

- write the config map yaml

- write the deployments yaml for both wp, in stable and canary versions, tag them via labels, and create deployment yaml for mariadb

- write the services yaml for wp and mariadb, in wp service, target both canary and stable versions

- write the ingress part

- read some docs about liveness/readiness check and add checks to mariadb (which can be connection to 3306 or exec mysqladmin) and wp deployments (http to port 80)

- launch all artifacts
```./commands.bash create```

- To delete artifacts created via docker create -f, I added a script command to delete everything created via yaml files.
```./commands.bash delete```

- add DNS entry
```./addDNS.bash dns```

- Load browser and point to http://wordpress-exercise-02.com/

### Problems found

- Can be hard to see if canary versions are being used, so i used NAMI_LOG environment and log wp output of canary and stable builds and see who was receiving the incoming calls, other option could have been a subtle difference in UI (blog name) that could be easier.


# Exercise III

## WP with external database

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-03* namespace.
* The WP site should use a external RDS database already populated which details
are provided in the **Credentials** section.
* Use a service to connect WP wit the external database.
* Use ConfigMaps & Secrets to configure both MariaDB and WP
* Every container should have the proper readiness and liveness probes
configured
* WP should be accessible through http/https using a NGINX Ingress on the URL
*wordpress-exercise-03.com* . The ingress should handle the TLS certificates.
* WP admin panel should be accessible using a different URL, e.g.
http://wordpress-exercise-03.com/my-custom-admin/. Configure NGINX ingress to do that
redirection.


### What I did

- create namespace 
```kubectl create namespace exercise03```

- change current context to namespace exercise02 so I don't mess with other namespaces
```./commands.bash context```

- create secrets for mariadb-root, mariadb-user and wp-user
```./commands.bash dbSecret```

- create certificate files for tls
```./commands.bash createCert```

- create secret for tls
```./commands.bash tlsSecret```

- write the config map yaml, check the bitnami/wordpress image and check which parameters are used to configure wp instance

- write the deployment yaml for wp

- write the services yaml for wp and mariadb

- write the ingress part

- read some docs about liveness/readiness check and add checks to mariadb (which can be connection to 3306 or exec mysqladmin) and wp deployments (http to port 80)

- launch all artifacts
```./commands.bash create```

- To delete artifacts created via docker create -f, I added a script command to delete everything created via yaml files.
```./commands.bash delete```

- add DNS entry
```./addDNS.bash dns```

- Load browser and point to http://wordpress-exercise-03.com/ check it works

- Load browser and point to https://wordpress-exercise-03.com/ check it works

- Load browser and point to https://wordpress-exercise-03.com/my-custom-admin/ and see the redirection to /wp-admin

### Problems found

- Redirection from /my-custom-admin to /wp-admin worked only if I added a trailing backslash in the URL /my-custom-admin/ <--


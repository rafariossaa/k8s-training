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

### Credentials

* Database
  * Hostname: kubernetes-training.cfxyxg2jnovx.us-east-1.rds.amazonaws.com
  * Name: k8s_training_db_XX
  * User: k8s_training_user_XX
  * Password: bitnami-training-2018
* Wordpress:
  * User: julio_iglesias
  * Password: ylosabes
  * Blog Name: La vida sigue igual
  * FirstName: Julio
  * LastName: Iglesias de la Cueva

## What to deliver

* YAML/JSON files with the definitions of every requested K8s object. Templates
are provided.
* If you created your resources from the command line, attach a bash script with
the commands used to create them. Sth like:

```
#!/bin/bash

kubectl create secret generic ...
```

Use the structure below on your PR To GitHub:

```
|
|-/session-01
|-/session-01/exercise-03/
|-/session-01/exercise-03/README.md
|-/session-01/exercise-03/commands.bash
|-/session-01/exercise-03/*.yaml
```

## Tips

* Use a linter to avoid syntax errors on your YAML/JSON files
* You can user the Docker Image below to run a linter

```
docker run -v /path-to-your-defs:/opt/data-definitions \
juanariza131/linter:latest
```

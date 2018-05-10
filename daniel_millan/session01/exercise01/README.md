# Exercise I

## WP + MariaDB

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-01* namespace.
* The WP site should use a MariaDB database.
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* WP should be accessible through http using a NGINX Ingress on the URL
*wordpress-exercise-01.com*.

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
|-/session-01/exercise-01/
|-/session-01/exercise-01/README.md
|-/session-01/exercise-01/commands.bash
|-/session-01/exercise-01/*.yaml
```

## Tips

* Use a linter to avoid syntax errors on your YAML/JSON files
* You can user the Docker Image below to run a linter

```
docker run -v /path-to-your-defs:/opt/data-definitions \
juanariza131/linter:latest
```

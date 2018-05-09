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

### What to deliver

* YAML/JSON files with the definitions of every requested K8s object. Templates
are provided.
* If you created your resources from the command line, attach a bash script with
the commands used to create them. Sth like:

```
#!/bin/bash

kubectl create secret generic ...
```

### Tips

* Use a linter to avoid syntax errors on your YAML/JSON files
* You can user the Docker Image below to run a linter

```
docker run -v /path-to-your-defs:/opt/data-definitions \
juanariza131/linter:latest
```

### Notes

You need to guarantee Session Affinity when using Canary Deployments. See
https://github.com/kubernetes/ingress-nginx/tree/master/docs/examples/affinity/cookie

It's necessary to edit ingress version used to... check in floobits !



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

### Notes

- As there was no other instuction, I have used the very same check for readiness and liveness. I should be better to have more specific checks in each case.

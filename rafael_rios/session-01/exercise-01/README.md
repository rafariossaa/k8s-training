# Exercise I

## WP + MariaDB

Create the K8s resources you need to deploy a WP site on your cluster using
MariaDB as database with the characteristics below:

* All the resources should be created under the *exercise-01* namespace.
* The WP site should use a MariaDB database.
* Use ConfigMaps and Secrets to configure both MariaDB and WP
* WP should be accessible through http using a NGINX Ingress on the URL
*wordpress-exercise-01.com*.

### Notes

- I've used envFrom to map the configmap to the env vars using the same name for the keys and the corresponding env var. May be it is more wise to map them manually and this way avoid unwanted collateral damages in case of a unexpected change.


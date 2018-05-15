# Here you can find files used in exercise 01.

## command.bash
This script executes all of the necessary steps to deploy k8s objects needed to solve exercise-01

## Most relevant aspects
1. PVC used to persist mariadb data (/bitnami dir) must use local-storage storageClassName so can bind to PV available at host. Idem for wordpress volume /bitnami.
2. We have used a ConfigMap named my-custom-cnf to map my_custom.cnf file to /bitnami/mariadb/config/ directory so we can customize database.
3. As of 10.1.28-r2 version bitnami/mariadb image uses uid 1001 instead of root so securitycontext fsgroup is needed for PV usage.

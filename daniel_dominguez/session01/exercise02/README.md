# Here you can find files used in exercise 02.

## command.bash
This script executes all of the necessary steps to deploy k8s objects needed to solve exercise-02

## Most relevant aspects
1. wordpress-deployment-canary.yaml deploy 1 pod with wordpress 4.9.5 while wordpress-deployment.yaml deploy 3 pods with wordpress 4.9.4. Both deployments share a subset of selector labels so both versions can be reached through the same service, but only 25% of users get to version 4.9.5.
2. Wordpress readiness and liveness probes have been achieved with httpGet, while mariadb ones have been configured with "exec command" -> - "mysqladmin ping -u$MARIADB_USER -p$MARIADB_PASSWORD. We have to use user/password in command because mariadb has been configured with ALLOW_EMPTY_PASSWORD=no.

 

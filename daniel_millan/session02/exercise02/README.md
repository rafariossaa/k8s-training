## Exercise 2: Create a LEMP chart
- Move MariaDB deployment to a StatefulSet
- Configures autoscale for the Nginx deployment. Make it optional in the chart.

# What I did

##### Copy lemp chart from previous exercise


####  Move MariaDB to a StatefulSet

Create mariadb-service.yaml as a headless service (clusterIP: None)

Edit mariadb.yaml, change to StatefulSet

Add volumeClaimTemplate and volumeMount of 1Gb to persist database

### Configure autoscale

First create a hpa.yaml and configure max and min replicas using values.yaml for max and min replicas

Add a "enabled" config value to values.yaml

Make hpa.yaml contents depend on that hpa.enabled config value

##### Commands
```
# Clean everything for this chart
helm delete --purge exercise02

# Install lemp chart
helm install lemp -n exercise02
```




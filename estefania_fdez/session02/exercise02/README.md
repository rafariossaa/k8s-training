## Exercise II: LEMP chart improvements

- Move MariaDB deployment to a StatefulSet
- Configures autoscale for the Nginx deployment. Make it optional in the chart.

## Tips:

- For the HorizontalPodAutoscaler to work, all the containers have to define the resources they will request.
- Take into account that if your requests are too high, you may run out of capacity in the cluster.

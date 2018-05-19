# Exercise II

## LEMP Chart

- Move mariaDB deployment to a StatefulSet
- Configures autoscale for the nginx deployment. Make it optional in the chart.

### Tips
- For the HorizontalPod Autoscaler to work, all the containers have to define the resources they will request.
- Take into account that if your requests are too high, youo may run out of capacity in the cluster.


### Disclaimer
- I reused an old version of my ex01 where I didn't use the git image, instead I downloaded the apps files through direct url.



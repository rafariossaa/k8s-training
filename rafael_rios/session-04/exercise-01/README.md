
I'm interested in the backend's metrics, so for this exercise I installed a wordpress with a mariadb with metrics 

Instructions
------------

1) Launch the deployment, for this I use the standard helm chart

helm install stable/wordpress --name wp --set serviceType=NodePort,mariadb.metrics.enabled=true

2) import in grafana the dashboard: 'MariaDB (wordpress)-1527431491534.json'

3) Launch the benchmark, for this I use a docker image that has ab installed. This will launch a test during 600s with a concurrency of 10

kubectl create -f ab.yaml

4) In the created dashboard there is an Alarm for the number of conexions in 5m, that is going to be triggerd with the benchmark in 3.


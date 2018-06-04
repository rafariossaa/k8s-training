Exercise 2 of session 2: LEMP chart improvements
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza) 
K8s Training user: pedro_respaldiza
---

# LEMP chart improvements

## Move MariaDB deployment to a StatefulSet
I have adapted the values for a StateFulSet.

## Configures autoscale for the Nginx deployment.
> Make it optional in the chart.
Autoscaling is optional, but enabled by default. You can disconnect or change the parameters of the autoscaling and container requirements.

It is necessary to have the metrics server active. In my Kubernetes cluster is previously installed. I have not included it in the chart because it is installed in kube-system namespace and we do not want to duplicate it every time we launch our application.


# Corrections

~~~
pedro_respaldiza/session2/exercise02/lemp/templates/mariadb-secrets.yaml
+    chart: {{ template "lemp.chart" . }}
+type: Opaque
+data:
+  dbName: {{ .Values.secretsmariadb.dbname }}
 @tompizmor
tompizmor 4 hours ago
you could encrypt the inputs here with a go template and a pipe
~~~
The answer is the same as in the first exercise. I have already implemented it in 3. Thanks for the indication.
~~~


Exercise 3 of session 2: Add postgres chart as dependency
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza) 
K8s Training user: pedro_respaldiza
---

# Add postgres chart as dependency
I have created the dependency of the postgres chart by adding it in the requirements.yaml file.The value "condition" make it optional, as default is disconnected.
The attributes of the user, database name and password of postgres have been added to the values.yaml of the LEMP chart, so it have my values and are modifiable. In the postgres Chart only the password is shared by secrets, so it is the only value that I have put in base64.

# Corrections
~~~
installing the third exercise I got this error:

Error: apiVersion "extensions/v1beta2" in lemp/templates/deployment.yaml is not available
Why are you using a different apiVersion for the deployment in this third exercise?
~~~
I made that change in one of the multiple tests. I really do not think it's necessary so I change the API version.
---
~~~
pedro_respaldiza/session2/exercise03/lemp/values.yaml
+
+add:
+  postgresql: false
+postgresPassword: aXVzZGpoMjMxCg==
 @tompizmor
tompizmor 4 hours ago
are you sure that the postgres database is taking this values?
~~~
I could not test, but no, it's not functional. I correct it.
---
~~~
pedro_respaldiza/session2/exercise03/lemp/requirements.yaml
@@ -0,0 +1,5 @@
+dependencies:
 @tompizmor
tompizmor 4 hours ago
usually, you also commit the requirements.lock file generated with the helm dependency update command
~~~
Added
~~~
helm dependency update lemp
Hang tight while we grab the latest from your chart repositories...
...Unable to get an update from the "local" chart repository (http://127.0.0.1:8879/charts):
	Get http://127.0.0.1:8879/charts/index.yaml: dial tcp 127.0.0.1:8879: connect: connection refused
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
Saving 1 charts
Downloading postgresql from repo https://kubernetes-charts.storage.googleapis.com/
Deleting outdated charts
~~~

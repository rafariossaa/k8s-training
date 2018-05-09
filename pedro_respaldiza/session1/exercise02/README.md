Exercise 2 of session 1: Mariadb deployment
Pedro Ignacio Respaldiza Hidalgo (aka Iñaki Respaldiza)
K8s Training user: pedro_respaldiza
---
# Exercise II: WordPress Improvements
I used the files from the previous exercise as a basis.
In wordpress.yaml I have indicated the corresponding image, I have indicated that it is stable and I have added a new canary deployment. I have deployed three copies of the stable version and one of the canary version.

As indicated, I changed the ingress image to be able to use
~~~
nginx.ingress.kubernetes.io/affinity: cookie
~~
This forces a user who visits one of the versions to have a persistent session based on cookies.

## Liveness and Readiness
I used the same command in the liveness and readiness test, but the initial dealy of the readiness test is shorter to prevent the containers from restarting unnecessarily until the deployment is finished.

## Bash Script
The bash script launches all elements. The sequence and the commands are the same as in exercise-01 because all the modifications have been made in the deployment files.

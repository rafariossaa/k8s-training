# K8S-training. Session 02 - Exercise 03.

The aim of this exercise is to add a postgresql chart as an optional dependency to the LEMP chart.

## How to install this chart

If you want postgresql:
Execute:  helm install lemp/ --set postgresql.enabled=true,postgresql.postgresUser=pg_user,postgresql.postgresPassword=pg_pass,postgresql.postgresDatabase=pg_database

If you don't want postgresql:
Execute:  helm install lemp/ --set postgresql.enabled=false

## Most relevant aspects

See values.yaml for additional customizing 

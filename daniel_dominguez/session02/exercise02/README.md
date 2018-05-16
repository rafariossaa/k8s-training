# K8S-training. Session 02 - Exercise 02.

The aim of this exercise is to congigure MariaDB as a StatefuSet deployment and add autoscaling to nginx-php deployment as an option.

## How to install this chart

Execute:  helm install lemp/

## Most relevant aspects
In addition to exercise-01 options you can enable or disable autoscaling setting autoscaling.enabled option:

helm install lemp/ --set autoscaling.enabled=false

See values.yaml for additional customizing 

# Exercise02

## Intro

The second exercise for K8s Bitnami Training includes the canary release procedure.

## Structure

This exercise its very similar with the exercise01. In addition, the project have an additional file for the canary release. The strategy for this canary release is 3 replicas for *stable* version / 1 replica for *canary* deployment. The wordpress deployments has been tracked with *stable* and *canary* values

To make effective this deployment, **nginx-ingress-controlleringress** has been updated with a new Docker image. The command used to edit this is:

```bash
# kubectl edit deployment --namespace=kube-system nginx-ingress-controller
```

And change this:

```
...
image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.10.2
...

```

## Deployment

For the deployment, you only need to execute the **commands.bash** script included in the root of folder exercise project.

```bash
# ./commands.bash
```

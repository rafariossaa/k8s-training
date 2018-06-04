Inside the virtual machine I have created a directory to use it as a data volume to assign it in the deployments
/tmp/data 


To change the version of the image of ingress I had to go to the namespace kube-system

kubectl edit deployment nginx-ingress-controller --namespace=kube-system 
and change the version of the image and can also be done 

 $ kubectl set image deployment nginx-ingress-controller quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.10.2 --all

Delete everything of this exercise
#kubectl delete ns exercise-02
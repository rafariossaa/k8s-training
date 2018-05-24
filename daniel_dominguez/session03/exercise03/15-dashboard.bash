kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl create clusterrolebinding --clusterrole=view --serviceaccount=kube-system:kubernetes-dashboard dashbordview


# Installation of kubernetes cluster

The scripts have the following name:
```NN_x_description_[node]```
Where NN is the step and x is the sequence in that step, some of them have a node part that indicate where to run that script.
There is a folder called scripts4server where are all the scripts to be run in the servers. This scripts are uploaded automatically by the fisrt step.
## Disclaimer
Unfortunately, the result doesn't work properlly, there is a problem that I need to find. It seems to be that the pods don't get an IP assigned. I tried weave and flannel but the same problem. I tried hard to get the error of what is happening but I couldn't find it. The logs of kubelet, kube-proxy, docker, the description of pods and deployments doesn't give me a enough information. 
At first moment I had a problem with the security group, but I fixed it.

## Steps
The scripts need to be run in the following order:

00_0_upload_scripts.bash
00-generate_CA_cert.sh
01_0_install_etcd_node0.bash
01_1_install_etcd_node1.bash
02_0_create_cert_admin.bash
02_0_install_kube-api_node0.bash
02_0_install_kube-api_node1.bash
03_0_create_admin_kubeconfig.bash
03_1_sign_certificate.bash
03_2_generate_kubeconfig_context.bash
04_0_install_kube-controller-manager_node0.bash
04_0_install_kube-controller-manager_node1.bash
04_1_update_kube_apiserver_node0.bash
04_1_update_kube_apiserver_node1.bash
05_0_install_kube-scheduler_node0.bash
05_0_install_kube-scheduler_node1.bash
06_0_generate_worker_cert_worker0.bash
06_0_generate_worker_cert_worker1.bash
06_1_upload_worker_certs.bash
06_2_sign_worker_cert_node0.bash
06_3_download_worker_cert.bash
06_4_install_kubelet_worker0.bash
06_5_upload_worker1_certs.bash
06_6_sign_worker_cert_node0.bash
06_7_download_worker_cert.bash
06_8_install_kubelet_worker1.bash
07_0_update_apiserver_node0.bash
07_0_update_apiserver_node1.bash
08_0_network_controller0.bash
08_0_network_controller1.bash
08_1_network_worker0.bash
08_1_network_worker1.bash
08_deploy_network_plugin.bash
09_0_generate_proxy_cert_worker0.bash
09_0_generate_proxy_cert_worker1.bash
09_1_upload_proxy0_cert.bash
09_2_sign_proxy0_cert_node0.bash
09_3_download_proxy0_cert.bash
09_4_install_kubeproxy_worker0.bash
09_5_upload_proxy1_cert.bash
09_6_sign_proxy0_cert_node0.bash
09_7_download_proxy0_cert.bash
09_8_install_kubeproxy_worker1.bash
10_0_install_kube_dns.bash
11_0_kubelet_config_dns_worker0.bash
11_0_kubelet_config_dns_worker1.bash
12_0_install_helm.bash

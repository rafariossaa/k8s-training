#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kube-proxy
#
# At the end of this script you will have running Kube Controller Manager
#

echo "Creating kube-proxy certificates"

#
# Create kube-proxy certificate
#
export KUBE_PROXY_CSR_PATH=/tmp/kube-proxy.csr

## Private key
openssl genrsa -out "/tmp/$KUBE_PROXY_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "/tmp/$KUBE_PROXY_KEY_PATH" -out "$KUBE_PROXY_CSR_PATH" -subj "/CN=system:kube-proxy/O=system:node-proxier"


export KUBE_PROXY_CERT_OUT_PATH=/tmp/kube-proxy.crt

## Certificate
openssl x509 -req -in "$KUBE_PROXY_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$KUBE_PROXY_CERT_OUT_PATH" -days 500 

#
# Create kubeconfig for kube-proxy
#
kubectl config set-cluster k8s-training --certificate-authority=/tmp/$KUBERNETES_CA_CERT_PATH --embed-certs=true --server=https://${CONTROLLER_PRIVATE_IPS[0]}:6443 --kubeconfig=/tmp/${KUBE_PROXY_KUBECONFIG_PATH}
kubectl config set-credentials system:kube-proxy --client-certificate=$KUBE_PROXY_CERT_OUT_PATH --client-key=/tmp/$KUBE_PROXY_KEY_PATH --embed-certs=true --kubeconfig=/tmp/${KUBE_PROXY_KUBECONFIG_PATH}
kubectl config set-context default --cluster=k8s-training --user=system:kube-proxy --kubeconfig=/tmp/${KUBE_PROXY_KUBECONFIG_PATH}
kubectl config use-context default --kubeconfig=/tmp/${KUBE_PROXY_KUBECONFIG_PATH}

#
# Install kube-proxy
#

for i in "${!WORKER_PUBLIC_IPS[@]}"
do

	echo "Installing kube-proxy"

        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "mkdir -p /tmp/$KUBERNETES_CERT_DIR; sudo mkdir -p $KUBERNETES_CERT_DIR"
        scp $KUBE_PROXY_CERT_OUT_PATH ubuntu@${WORKER_PUBLIC_IPS[$i]}:/tmp/$KUBE_PROXY_CERT_PATH
        scp /tmp/$KUBERNETES_CA_CERT_PATH ubuntu@${WORKER_PUBLIC_IPS[$i]}:/tmp/$KUBERNETES_CA_CERT_PATH
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_PROXY_CERT_PATH $KUBE_PROXY_CERT_PATH; sudo mv /tmp/$KUBERNETES_CA_CERT_PATH $KUBERNETES_CA_CERT_PATH"


        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "mkdir -p `dirname /tmp/$KUBE_PROXY_KUBECONFIG_PATH`; sudo mkdir -p `dirname $KUBE_PROXY_KUBECONFIG_PATH`"
        scp /tmp/$KUBE_PROXY_KUBECONFIG_PATH $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/$KUBE_PROXY_KUBECONFIG_PATH
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_PROXY_KUBECONFIG_PATH $KUBE_PROXY_KUBECONFIG_PATH"


        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo wget -q $KUBE_PROXY_URL -P $KUBERNETES_BIN_DIR"
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo chmod +x $KUBERNETES_BIN_DIR/kube-proxy"


## Create systemd service
cat << EOF | tee "/tmp/$KUBE_PROXY_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kube-proxy

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kube-proxy \\
  --kubeconfig=${KUBE_PROXY_KUBECONFIG_PATH} \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

        scp /tmp/$KUBE_PROXY_SYSTEMD_SERVICE_PATH $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/kube-proxy.service $KUBE_PROXY_SYSTEMD_SERVICE_PATH"

        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl daemon-reload"
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl enable kube-proxy.service"
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl restart kube-proxy.service"
        sleep 5
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl status kube-proxy.service"

done


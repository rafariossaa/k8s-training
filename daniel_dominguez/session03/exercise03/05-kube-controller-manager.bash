#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kube-controller-manager
#
# At the end of this script you will have running Kube Controller Manager
#

echo "Creating kube-controller-manager certificates"

#
# Create kube-controller-manager certificate
#
export KUBE_CONTROLLER_MANAGER_CSR_PATH=/tmp/kube-controller-manager_server.csr

## Private key
openssl genrsa -out "/tmp/$KUBE_CONTROLLER_MANAGER_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "/tmp/$KUBE_CONTROLLER_MANAGER_KEY_PATH" -out "$KUBE_CONTROLLER_MANAGER_CSR_PATH" -subj "/CN=system:kube-controller-manager/O=system:kube-controller-manager"
## Certificate
openssl x509 -req -in "$KUBE_CONTROLLER_MANAGER_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "/tmp/$KUBE_CONTROLLER_MANAGER_CERT_PATH" -days 500 


#
# Install kubectl for creating the required kubeconfig
#
#wget -q "$KUBECTL_URL" -P "$KUBERNETES_BIN_DIR"
#chmod +x "$KUBERNETES_BIN_DIR/kubectl"

#
# Create kubeconfig for kube-controller-manager
#
kubectl config set-cluster k8s-training --certificate-authority=/tmp/$KUBERNETES_CA_CERT_PATH --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=/tmp/${KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH}
kubectl config set-credentials system:kube-controller-manager --client-certificate=/tmp/$KUBE_CONTROLLER_MANAGER_CERT_PATH --client-key=/tmp/$KUBE_CONTROLLER_MANAGER_KEY_PATH --embed-certs=true --kubeconfig=/tmp/${KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH}
kubectl config set-context default --cluster=k8s-training --user=system:kube-controller-manager --kubeconfig=/tmp/${KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH}
kubectl config use-context default --kubeconfig=/tmp/${KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH}

#
# Install kube-controller-manager
#

echo "Installing kube-controller-manager"


# Download and extract
for i in "${!CONTROLLER_PUBLIC_IPS[@]}"
do
        scp /tmp/$KUBE_CONTROLLER_MANAGER_KEY_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_CONTROLLER_MANAGER_KEY_PATH
        scp /tmp/$KUBE_CONTROLLER_MANAGER_CERT_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_CONTROLLER_MANAGER_CERT_PATH
	ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "mkdir -p `dirname /tmp/$KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH`; sudo mkdir -p `dirname $KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH`"
	scp /tmp/$KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH

	ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_CONTROLLER_MANAGER_KEY_PATH $KUBE_CONTROLLER_MANAGER_KEY_PATH; sudo mv /tmp/$KUBE_CONTROLLER_MANAGER_CERT_PATH $KUBE_CONTROLLER_MANAGER_CERT_PATH; sudo chown root:root $KUBERNETES_CERT_DIR/*; sudo mv /tmp/$KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH $KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH"

	ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo wget -q $KUBE_CONTROLLER_MANAGER_URL -P $KUBERNETES_BIN_DIR"
	ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo chmod +x $KUBERNETES_BIN_DIR/kube-controller-manager"


## Create systemd service
cat << EOF | tee "/tmp/$KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kube-controller-manager

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kube-controller-manager \\
  --cluster-name=kubernetes \\
  --kubeconfig=${KUBE_CONTROLLER_MANAGER_KUBECONFIG_PATH} \\
  --use-service-account-credentials=true \\
  --service-account-private-key-file=${SERVICE_ACCOUNT_GEN_KEY_PATH} \\
  --root-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --cluster-cidr=$PODS_NET \\
  --allocate-node-cidrs=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

        scp /tmp/$KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_PATH
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_PATH $KUBE_CONTROLLER_MANAGER_SYSTEMD_SERVICE_PATH"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl daemon-reload"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl enable kube-controller-manager.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl restart kube-controller-manager.service"
        sleep 5
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl status kube-controller-manager.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "rm /tmp/kube-controller-manager* -rf"

done

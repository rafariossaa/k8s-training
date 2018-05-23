#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kube-scheduler
#
# At the end of this script you will have running Kube Controller Manager
#

echo "Creating kube-scheduler certificates"

#
# Create kube-scheduler certificate
#
export KUBE_SCHEDULER_CSR_PATH=/tmp/kube-scheduler_server.csr

## Private key
openssl genrsa -out "/tmp/$KUBE_SCHEDULER_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "/tmp/$KUBE_SCHEDULER_KEY_PATH" -out "$KUBE_SCHEDULER_CSR_PATH" -subj "/CN=system:kube-scheduler/O=system:kube-scheduler"


## Certificate
openssl x509 -req -in "$KUBE_SCHEDULER_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "/tmp/$KUBE_SCHEDULER_CERT_PATH" -days 500 

#
# Create kubeconfig for kube-scheduler
#
kubectl config set-cluster k8s-training --certificate-authority=/tmp/$KUBERNETES_CA_CERT_PATH --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=/tmp/${KUBE_SCHEDULER_KUBECONFIG_PATH}
kubectl config set-credentials system:kube-scheduler --client-certificate=/tmp/$KUBE_SCHEDULER_CERT_PATH --client-key=/tmp/$KUBE_SCHEDULER_KEY_PATH --embed-certs=true --kubeconfig=/tmp/${KUBE_SCHEDULER_KUBECONFIG_PATH}
kubectl config set-context default --cluster=k8s-training --user=system:kube-scheduler --kubeconfig=/tmp/${KUBE_SCHEDULER_KUBECONFIG_PATH}
kubectl config use-context default --kubeconfig=/tmp/${KUBE_SCHEDULER_KUBECONFIG_PATH}

#
# Install kube-scheduler
#

echo "Installing kube-scheduler"

for i in "${!CONTROLLER_PUBLIC_IPS[@]}"
do
        scp /tmp/$KUBE_SCHEDULER_KEY_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_SCHEDULER_KEY_PATH
        scp /tmp/$KUBE_SCHEDULER_CERT_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_SCHEDULER_CERT_PATH
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "mkdir -p `dirname /tmp/$KUBE_SCHEDULER_KUBECONFIG_PATH`; sudo mkdir -p `dirname $KUBE_SCHEDULER_KUBECONFIG_PATH`"
        scp /tmp/$KUBE_SCHEDULER_KUBECONFIG_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_SCHEDULER_KUBECONFIG_PATH

        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_SCHEDULER_KEY_PATH $KUBE_SCHEDULER_KEY_PATH; sudo mv /tmp/$KUBE_SCHEDULER_CERT_PATH $KUBE_SCHEDULER_CERT_PATH; sudo chown root:root $KUBERNETES_CERT_DIR/*; sudo mv /tmp/$KUBE_SCHEDULER_KUBECONFIG_PATH $KUBE_SCHEDULER_KUBECONFIG_PATH"

        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo wget -q $KUBE_SCHEDULER_URL -P $KUBERNETES_BIN_DIR"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo chmod +x $KUBERNETES_BIN_DIR/kube-scheduler"


## Create systemd service
cat << EOF | tee "/tmp/$KUBE_SCHEDULER_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kube-scheduler

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kube-scheduler \\
  --kubeconfig=${KUBE_SCHEDULER_KUBECONFIG_PATH} \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

        scp /tmp/$KUBE_SCHEDULER_SYSTEMD_SERVICE_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_SCHEDULER_SYSTEMD_SERVICE_PATH
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_SCHEDULER_SYSTEMD_SERVICE_PATH $KUBE_SCHEDULER_SYSTEMD_SERVICE_PATH"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl daemon-reload"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl enable kube-scheduler.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl restart kube-scheduler.service"
        sleep 5
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl status kube-scheduler.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "rm /tmp/kube-scheduler* -rf"
done

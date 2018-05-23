#!/bin/bash

source ./common.bash

cp /tmp/kube-proxy.crt $KUBE_PROXY_CERT_PATH
#
# Create kubeconfig for kube-proxy
#
kubectl config set-cluster k8s-training --certificate-authority=$KUBERNETES_CA_CERT_PATH --embed-certs=true --server=https://${CONTROLLER0_PRIVATE_IP}:6443 --kubeconfig=${KUBE_PROXY_KUBECONFIG_PATH}
kubectl config set-credentials system:kube-proxy --client-certificate=$KUBE_PROXY_CERT_PATH --client-key=$KUBE_PROXY_KEY_PATH --embed-certs=true --kubeconfig=${KUBE_PROXY_KUBECONFIG_PATH}
kubectl config set-context default --cluster=k8s-training --user=system:kube-proxy --kubeconfig=${KUBE_PROXY_KUBECONFIG_PATH}
kubectl config use-context default --kubeconfig=${KUBE_PROXY_KUBECONFIG_PATH}

#
# Install kube-proxy
#

echo "Installing kube-proxy"

## Download
wget -q "$KUBE_PROXY_URL" -P "$KUBERNETES_BIN_DIR"
chmod +x "$KUBERNETES_BIN_DIR/kube-proxy"

## Create systemd service
cat << EOF | sudo tee "$KUBE_PROXY_SYSTEMD_SERVICE_PATH"
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

systemctl daemon-reload
systemctl enable kube-proxy.service
systemctl restart kube-proxy.service

# Cleanup
rm /tmp/kube-proxy* -rf


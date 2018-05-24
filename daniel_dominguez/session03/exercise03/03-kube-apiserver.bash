#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: API Server
#
# At the end of this script you will have running API Server
#

echo "Creating kube-apiserver certificates"

#
# Create kube-apiserver server certificate
#
export KUBE_APISERVER_CSR_PATH=/tmp/kube-apiserver_server.csr

## Private key
mkdir -p `dirname /tmp/$KUBE_APISERVER_KEY_PATH`
openssl genrsa -out "/tmp/$KUBE_APISERVER_KEY_PATH" 2048

export KUBE_APISERVER_CERT_CONFIG=/tmp/kube-apiserver_cert_config.conf

first_loop=1
for i in "${!CONTROLLER_PRIVATE_IPS[@]}"
do
        (( $first_loop )) && IPS="IP.$(($i+4)) = ${CONTROLLER_PRIVATE_IPS[$i]}" || IPS="$IPS\nIP.$(($i+4)) = ${CONTROLLER_PRIVATE_IPS[$i]}"
        unset first_loop
done

cat <<EOF | tee ${KUBE_APISERVER_CERT_CONFIG}
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS = *.${CLUSTER_DOMAIN}
IP.1 = 127.0.0.1
IP.2 = ${CONTROLLER_PUBLIC_IP}
IP.3 = ${KUBE_APISERVER_SERVICE_IP}
`echo -e ${IPS}`
EOF

## Certificate sign request
openssl req -new -key "/tmp/$KUBE_APISERVER_KEY_PATH" -out "$KUBE_APISERVER_CSR_PATH" -subj "/CN=kubernetes/O=Kubernetes" -config ${KUBE_APISERVER_CERT_CONFIG}
## Certificate
openssl x509 -req -in "$KUBE_APISERVER_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "/tmp/$KUBE_APISERVER_CERT_PATH"  -extensions v3_req -days 500 -extfile ${KUBE_APISERVER_CERT_CONFIG}

#
# Create certificate for service account generation
#
export SERVICE_ACCOUNT_GEN_CSR_PATH=/tmp/service-account-gen.csr

## Private key
openssl genrsa -out "/tmp/$SERVICE_ACCOUNT_GEN_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "/tmp/$SERVICE_ACCOUNT_GEN_KEY_PATH" -out "$SERVICE_ACCOUNT_GEN_CSR_PATH" -subj "/CN=service-accounts/O=Kubernetes"
## Certificate
openssl x509 -req -in "$SERVICE_ACCOUNT_GEN_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "/tmp/$SERVICE_ACCOUNT_GEN_CERT_PATH" -days 500


#
# Install kube-apiserver
#

echo "Installing kube-apiserver"

first_loop=1
for p in "${!CONTROLLER_PRIVATE_IPS[@]}"
do
        (( $first_loop )) &&
                etcdcluster="https://${CONTROLLER_PRIVATE_IPS[$p]}:2379" ||
                etcdcluster="${etcdcluster},https://${CONTROLLER_PRIVATE_IPS[$p]}:2379"
        unset first_loop
done


# Download and extract
for i in "${!CONTROLLER_PUBLIC_IPS[@]}"
do
        scp /tmp/$KUBE_APISERVER_KEY_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_APISERVER_KEY_PATH
        scp /tmp/$KUBE_APISERVER_CERT_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_APISERVER_CERT_PATH
        scp /tmp/$SERVICE_ACCOUNT_GEN_KEY_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$SERVICE_ACCOUNT_GEN_KEY_PATH
        scp /tmp/$SERVICE_ACCOUNT_GEN_CERT_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$SERVICE_ACCOUNT_GEN_CERT_PATH

        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_APISERVER_KEY_PATH $KUBE_APISERVER_KEY_PATH; sudo mv /tmp/$KUBE_APISERVER_CERT_PATH $KUBE_APISERVER_CERT_PATH; sudo mv /tmp/$SERVICE_ACCOUNT_GEN_KEY_PATH $SERVICE_ACCOUNT_GEN_KEY_PATH; sudo mv /tmp/$SERVICE_ACCOUNT_GEN_CERT_PATH $SERVICE_ACCOUNT_GEN_CERT_PATH; sudo chown root:root $KUBERNETES_CERT_DIR/*"

        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo wget -q $KUBE_APISERVER_URL -P $KUBERNETES_BIN_DIR"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo chmod +x $KUBERNETES_BIN_DIR/kube-apiserver"


mkdir -p `dirname /tmp/$KUBE_APISERVER_SYSTEMD_SERVICE_PATH`
## Create systemd service
cat << EOF | tee "/tmp/$KUBE_APISERVER_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kube-apiserver

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kube-apiserver \\
  --advertise-address=${CONTROLLER_PRIVATE_IPS[$i]} \\
  --tls-cert-file=${KUBE_APISERVER_CERT_PATH} \\
  --tls-private-key-file=${KUBE_APISERVER_KEY_PATH} \\
  --client-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --etcd-cafile=${KUBERNETES_CA_CERT_PATH} \\
  --etcd-certfile=${ETCD_CLIENT_CERT_PATH} \\
  --etcd-keyfile=${ETCD_CLIENT_KEY_PATH} \\
  --etcd-servers=${etcdcluster} \\
  --service-account-key-file=${SERVICE_ACCOUNT_GEN_CERT_PATH} \\
  --service-cluster-ip-range=${SERVICE_CLUSTERIP_NET} \\
  --authorization-mode=RBAC,Node \\
  --bind-address=0.0.0.0 \\
  --allow-privileged=true \\
  --v=2 \\
  --service-node-port-range=$NODEPORT_RANGE
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

        scp /tmp/$KUBE_APISERVER_SYSTEMD_SERVICE_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$KUBE_APISERVER_SYSTEMD_SERVICE_PATH
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBE_APISERVER_SYSTEMD_SERVICE_PATH $KUBE_APISERVER_SYSTEMD_SERVICE_PATH"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl daemon-reload"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl enable kube-apiserver.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl restart kube-apiserver.service"
        sleep 5
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl status kube-apiserver.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "rm /tmp/kube-apiserver* -rf"
done

# Create secret for Calico

echo "End of kube-apiserver step"

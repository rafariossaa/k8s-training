#!/bin/bash

source ./common.bash

#
# Cluster storage backend: etcd
#
# At the end of this script you will have a running etcd instance to be used
# by Kubernetes Control Plane
#

echo "Creating etcd certificates"

mkdir -p "/tmp/$ETCD_CERT_DIR"


#
# Create etcd server certificate
#
export ETCD_SERVER_CSR_PATH=/tmp/etcd_server.csr

## Private key
openssl genrsa -out "/tmp/$ETCD_SERVER_KEY_PATH" 2048

export ETCD_SERVER_CERT_CONFIG=/tmp/etcd_cert_config.conf

first_loop=1
for i in "${!CONTROLLER_PRIVATE_IPS[@]}"
do
	(( $first_loop )) && IPS="IP.$(($i+2)) = ${CONTROLLER_PRIVATE_IPS[$i]}" || IPS="$IPS\nIP.$(($i+2)) = ${CONTROLLER_PRIVATE_IPS[$i]}"
   	unset first_loop
done

cat <<EOF | tee ${ETCD_SERVER_CERT_CONFIG}
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
extendedKeyUsage = clientAuth,serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = *.${CLUSTER_DOMAIN}
IP.1 = 127.0.0.1
`echo -e ${IPS}`
EOF


## Certificate sign request
openssl req -new -key "/tmp/$ETCD_SERVER_KEY_PATH" -out "$ETCD_SERVER_CSR_PATH" -subj "/CN=etcd/O=etcd" -config ${ETCD_SERVER_CERT_CONFIG}
## Certificate
openssl x509 -req -in "$ETCD_SERVER_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "/tmp/$ETCD_SERVER_CERT_PATH"  -extensions v3_req -days 500 -extfile ${ETCD_SERVER_CERT_CONFIG}

#
# Create etcd client certificate
#
export ETCD_CLIENT_CSR_PATH=/tmp/etcd_client.csr

## Private key
openssl genrsa -out "/tmp/$ETCD_CLIENT_KEY_PATH" 2048

## Certificate sign request
openssl req -new -key "/tmp/$ETCD_CLIENT_KEY_PATH" -out "$ETCD_CLIENT_CSR_PATH" -subj "/CN=etcd-client/O=etcd"

## Certificate
openssl x509 -req -in "$ETCD_CLIENT_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "/tmp/$ETCD_CLIENT_CERT_PATH" -days 500


# Create secret for Calico

cat /tmp/${ETCD_CLIENT_KEY_PATH} | base64 > etcd-key
cat /tmp/${ETCD_CLIENT_CERT_PATH} | base64 > etcd-cert
cat /tmp/${KUBERNETES_CA_CERT_PATH} | base64 > etcd-ca

exit 0

#
# Install etcd
#

echo "Installing etcd"

first_loop=1
for p in "${!CONTROLLER_PRIVATE_IPS[@]}"
do
        (( $first_loop )) && 
		etcdcluster="etcd${p}=https://${CONTROLLER_PRIVATE_IPS[$p]}:2380" ||
		etcdcluster="${etcdcluster},etcd${p}=https://${CONTROLLER_PRIVATE_IPS[$p]}:2380"
	unset first_loop
done

mkdir -p /tmp/$SYSTEMD_SERVICE_DIR

## Download and extract
for i in "${!CONTROLLER_PUBLIC_IPS[@]}"
do
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "mkdir -p /tmp/$ETCD_CERT_DIR; sudo mkdir -p $ETCD_CERT_DIR; mkdir -p /tmp/$SYSTEMD_SERVICE_DIR"
        scp /tmp/$ETCD_SERVER_KEY_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$ETCD_SERVER_KEY_PATH
        scp /tmp/$ETCD_SERVER_CERT_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$ETCD_SERVER_CERT_PATH
        scp /tmp/$ETCD_CLIENT_KEY_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$ETCD_CLIENT_KEY_PATH
        scp /tmp/$ETCD_CLIENT_CERT_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$ETCD_CLIENT_CERT_PATH
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$ETCD_CERT_DIR/* $ETCD_CERT_DIR; sudo chown root:root $ETCD_CERT_DIR/*"

	ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "wget -q $ETCD_TARBALL_URL -P /tmp"
	ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "tar xf /tmp/$ETCD_TARBALL_NAME -C /tmp"
	ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/etcd-v${ETCD_VERSION}-linux-amd64/etcd* $ETCD_BIN_DIR"

## Create systemd service
cat << EOF | tee /tmp/$ETCD_SYSTEMD_SERVICE_PATH
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=${ETCD_BIN_DIR}/etcd \\
  --name etcd${i} \\
  --cert-file=${ETCD_SERVER_CERT_PATH} \\
  --key-file=${ETCD_SERVER_KEY_PATH} \\
  --peer-cert-file=${ETCD_SERVER_CERT_PATH} \\
  --peer-key-file=${ETCD_SERVER_KEY_PATH} \\
  --trusted-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --peer-trusted-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --peer-client-cert-auth \\
  --initial-advertise-peer-urls https://${CONTROLLER_PRIVATE_IPS[$i]}:2380 \\
  --listen-peer-urls https://${CONTROLLER_PRIVATE_IPS[$i]}:2380 \\
  --client-cert-auth \\
  --advertise-client-urls https://${CONTROLLER_PRIVATE_IPS[$i]}:2379 \\
  --listen-client-urls https://${CONTROLLER_PRIVATE_IPS[$i]}:2379,https://127.0.0.1:2379 \\
  --initial-cluster-token etcd-cluster-1 \\
  --initial-cluster $etcdcluster \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

	scp /tmp/$ETCD_SYSTEMD_SERVICE_PATH $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]}:/tmp/$ETCD_SYSTEMD_SERVICE_PATH
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo mv /tmp/$ETCD_SYSTEMD_SERVICE_PATH $ETCD_SYSTEMD_SERVICE_PATH"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl daemon-reload"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl enable etcd.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl restart etcd.service"
	sleep 5
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "sudo systemctl status etcd.service"
        ssh $UBUNTU_USER@${CONTROLLER_PUBLIC_IPS[$i]} "rm /tmp/etcd* -rf"
	
done


echo "End of etcd step"

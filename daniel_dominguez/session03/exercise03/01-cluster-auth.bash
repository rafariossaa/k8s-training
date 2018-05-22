#!/bin/bash

source ./common.bash

#
# Cluster CA creation scripts, using OpenSSL
#
# At the end of this script, you will have a Cluster Certificate Authority 
# to create certificates for the rest of the components
#
#       - ca.crt (CA Certificate)
#       - ca.key (CA private key)
#

echo "Creating Cluster Authority locally"

# Create folder for storing keys, we will use /etc/kubernetes/pki (based on examples like Kubeadm)

mkdir -p "/tmp/$KUBERNETES_CERT_DIR"

# Create CA key
openssl genrsa -out "/tmp/$KUBERNETES_CA_KEY_PATH" 2048

# Create CA certificate
openssl req -x509 -new -nodes -key "/tmp/$KUBERNETES_CA_KEY_PATH" -days 10000 -out "/tmp/$KUBERNETES_CA_CERT_PATH" -subj "/CN=Kubernetes/O=Kubernetes"  

echo "Copying CA certs to controllers"

for CONTROLLER_PUBLIC_IP in "${CONTROLLER_PUBLIC_IPS[@]}"
do
	ssh $UBUNTU_USER@$CONTROLLER_PUBLIC_IP "mkdir -p /tmp/$KUBERNETES_CERT_DIR; sudo mkdir -p $KUBERNETES_CERT_DIR"
	scp /tmp/$KUBERNETES_CA_KEY_PATH $UBUNTU_USER@$CONTROLLER_PUBLIC_IP:/tmp/$KUBERNETES_CA_KEY_PATH
	scp /tmp/$KUBERNETES_CA_CERT_PATH $UBUNTU_USER@$CONTROLLER_PUBLIC_IP:/tmp/$KUBERNETES_CA_CERT_PATH
	ssh $UBUNTU_USER@$CONTROLLER_PUBLIC_IP "sudo mv /tmp/$KUBERNETES_CERT_DIR/* $KUBERNETES_CERT_DIR; sudo chown root:root $KUBERNETES_CERT_DIR/*"
done

#rm /tmp/$KUBERNETES_CA_KEY_PATH /tmp/$KUBERNETES_CA_CERT_PATH

echo "End of Cluster Auth step"


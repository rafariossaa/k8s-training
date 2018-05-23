#!/bin/bash

source ./common.bash


## Copy the request to the server (NOT THE PROPER WAY)
mkdir tmp
rm tmp/*
export KUBELET_CSR_PATH=/tmp/kubelet.csr
export KUBELET_CERT_CONFIG=/tmp/kubelet_cert_config.conf
export KUBELET_CERT_OUT_PATH=/tmp/kubelet.crt

# Download the generated certificate (NOT THE PROPER WAY)
scp -i $USER_SSH_CERT  ubuntu@$CONTROLLER0_PUBLIC_IP:$KUBELET_CERT_OUT_PATH tmp/
scp -i $USER_SSH_CERT  ubuntu@$CONTROLLER0_PUBLIC_IP:/tmp/ca.crt tmp/

scp -i $USER_SSH_CERT tmp/kubelet.crt    $USER_SSH@$WORKER1_PUBLIC_IP:/tmp/
scp -i $USER_SSH_CERT tmp/ca.crt    $USER_SSH@$WORKER1_PUBLIC_IP:/tmp/
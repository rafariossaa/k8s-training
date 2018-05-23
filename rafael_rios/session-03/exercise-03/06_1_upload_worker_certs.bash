#!/bin/bash

source ./common.bash


## Copy the request to the server (NOT THE PROPER WAY)
mkdir tmp
rm tmp/*
export KUBELET_CSR_PATH=/tmp/kubelet.csr
export KUBELET_CERT_CONFIG=/tmp/kubelet_cert_config.conf

scp -i $USER_SSH_CERT $USER_SSH@$WORKER0_PUBLIC_IP:$KUBELET_CSR_PATH tmp/
scp -i $USER_SSH_CERT $USER_SSH@$WORKER0_PUBLIC_IP:$KUBELET_CERT_CONFIG tmp/

scp -i $USER_SSH_CERT tmp/*    ubuntu@$CONTROLLER0_PUBLIC_IP:/tmp/

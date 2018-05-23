#!/bin/bash

source ./common.bash


## Copy the request to the server (NOT THE PROPER WAY)
mkdir tmp
rm tmp/*
export KUBE_PROXY_CSR_PATH=/tmp/kube-proxy.csr

scp -i $USER_SSH_CERT $USER_SSH@$WORKER1_PUBLIC_IP:$KUBE_PROXY_CSR_PATH tmp/

scp -i $USER_SSH_CERT tmp/*    ubuntu@$CONTROLLER0_PUBLIC_IP:/tmp/

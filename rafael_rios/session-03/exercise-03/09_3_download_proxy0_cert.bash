#!/bin/bash

source ./common.bash

#
# This part is to be executed again in the worker node
#
export KUBE_PROXY_CERT_OUT_PATH=/tmp/kube-proxy.crt



# Download the generated certificate (NOT THE PROPER WAY)
scp -i $USER_SSH_CERT  ubuntu@$CONTROLLER0_PUBLIC_IP:$KUBE_PROXY_CERT_OUT_PATH tmp/
scp -i $USER_SSH_CERT  ubuntu@$CONTROLLER0_PUBLIC_IP:/tmp/ca.crt tmp/

scp -i $USER_SSH_CERT tmp/kube-proxy.crt    $USER_SSH@$WORKER0_PUBLIC_IP:/tmp/
scp -i $USER_SSH_CERT tmp/ca.crt    $USER_SSH@$WORKER0_PUBLIC_IP:/tmp/


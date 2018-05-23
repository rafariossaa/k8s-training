#!/bin/bash

source ./common.bash

# echo "Deleting dir"
# ssh -i $USER_SSH_CERT $USER_SSH@$CONTROLLER0_PUBLIC_IP sudo rm -rf  $SCRIPTS_DIR
# ssh -i $USER_SSH_CERT $USER_SSH@$CONTROLLER1_PUBLIC_IP sudo rm -rf  $SCRIPTS_DIR
# ssh -i $USER_SSH_CERT $USER_SSH@$WORKER0_PUBLIC_IP sudo rm -rf  $SCRIPTS_DIR
# ssh -i $USER_SSH_CERT $USER_SSH@$WORKER1_PUBLIC_IP sudo rm -rf  $SCRIPTS_DIR


# echo "Creating dir"
# ssh -i $USER_SSH_CERT $USER_SSH@$CONTROLLER0_PUBLIC_IP sudo mkdir -m777 $SCRIPTS_DIR
# ssh -i $USER_SSH_CERT $USER_SSH@$CONTROLLER1_PUBLIC_IP sudo mkdir -m777 $SCRIPTS_DIR
# ssh -i $USER_SSH_CERT $USER_SSH@$WORKER0_PUBLIC_IP sudo mkdir -m777 $SCRIPTS_DIR
# ssh -i $USER_SSH_CERT $USER_SSH@$WORKER1_PUBLIC_IP sudo mkdir -m777 $SCRIPTS_DIR

# Copy common.bash to all nodes
echo "Copying files"
scp -i $USER_SSH_CERT  scripts4servers/* $USER_SSH@$CONTROLLER0_PUBLIC_IP:$SCRIPTS_DIR
scp -i $USER_SSH_CERT  scripts4servers/* $USER_SSH@$CONTROLLER1_PUBLIC_IP:$SCRIPTS_DIR
scp -i $USER_SSH_CERT  scripts4servers/* $USER_SSH@$WORKER0_PUBLIC_IP:$SCRIPTS_DIR
scp -i $USER_SSH_CERT  scripts4servers/* $USER_SSH@$WORKER1_PUBLIC_IP:$SCRIPTS_DIR

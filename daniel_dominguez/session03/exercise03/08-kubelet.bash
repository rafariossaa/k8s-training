#!/bin/bash

source ./common.bash

#
# Kubernetes Control Plane: kubelet
#
# At the end of this script you will have running Kube Controller Manager
#

#
# This part must be executed in the worker nodes
#

echo "Creating kubelet certificates"

mkdir -p "/tmp/$KUBERNETES_CERT_DIR"

#
# Create kubelet certificate
#
export KUBELET_CSR_PATH=/tmp/kubelet.csr

## Private key
openssl genrsa -out "/tmp/$KUBELET_KEY_PATH" 2048

export KUBELET_CERT_CONFIG=/tmp/kubelet_cert_config.conf


for i in "${!WORKER_PUBLIC_IPS[@]}"
do

HOSTNAME=`ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "hostname"`

cat <<EOF | tee ${KUBELET_CERT_CONFIG}
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req]
subjectAltName = @alt_names
[alt_names]
DNS = $HOSTNAME
IP = ${WORKER_PRIVATE_IPS[$i]}
IP.1 = 127.0.0.1
EOF


	## Certificate sign request
	openssl req -new -key "/tmp/$KUBELET_KEY_PATH" -out "$KUBELET_CSR_PATH" -subj "/CN=system:node:$HOSTNAME/O=system:nodes" -config ${KUBELET_CERT_CONFIG}

	export KUBELET_CERT_OUT_PATH=/tmp/kubelet.crt

	## Certificate
	openssl x509 -req -in "$KUBELET_CSR_PATH" -CA "/tmp/$KUBERNETES_CA_CERT_PATH" -CAkey "/tmp/$KUBERNETES_CA_KEY_PATH" -CAcreateserial -out "$KUBELET_CERT_OUT_PATH" -days 500 -extensions v3_req -extfile ${KUBELET_CERT_CONFIG}

	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "mkdir -p /tmp/$KUBERNETES_CERT_DIR; sudo mkdir -p $KUBERNETES_CERT_DIR"
	scp $KUBELET_CERT_OUT_PATH ubuntu@${WORKER_PUBLIC_IPS[$i]}:/tmp/$KUBELET_CERT_PATH
	scp /tmp/$KUBERNETES_CA_CERT_PATH ubuntu@${WORKER_PUBLIC_IPS[$i]}:/tmp/$KUBERNETES_CA_CERT_PATH
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBELET_CERT_PATH $KUBELET_CERT_PATH; sudo mv /tmp/$KUBERNETES_CA_CERT_PATH $KUBERNETES_CA_CERT_PATH"

	#
	# Create kubeconfig for kubelet
	#
	kubectl config set-cluster k8s-training --certificate-authority=/tmp/$KUBERNETES_CA_CERT_PATH --embed-certs=true --server=https://${CONTROLLER_PRIVATE_IPS[0]}:6443 --kubeconfig=/tmp/${KUBELET_KUBECONFIG_PATH}
	kubectl config set-credentials system:node:$HOSTNAME --client-certificate=$KUBELET_CERT_OUT_PATH --client-key=/tmp/$KUBELET_KEY_PATH --embed-certs=true --kubeconfig=/tmp/${KUBELET_KUBECONFIG_PATH}
	kubectl config set-context default --cluster=k8s-training --user=system:node:$HOSTNAME --kubeconfig=/tmp/${KUBELET_KUBECONFIG_PATH}
	kubectl config use-context default --kubeconfig=/tmp/${KUBELET_KUBECONFIG_PATH}

	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "mkdir -p `dirname /tmp/$KUBELET_KUBECONFIG_PATH`; sudo mkdir -p `dirname $KUBELET_KUBECONFIG_PATH`"
	scp /tmp/$KUBELET_KUBECONFIG_PATH $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/$KUBELET_KUBECONFIG_PATH
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/$KUBELET_KUBECONFIG_PATH $KUBELET_KUBECONFIG_PATH"

	#
	# Install dependencies
	#

	## cni
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mkdir -p /opt/cni/bin"
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mkdir -p /etc/cni/net.d"
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo wget -q $CNI_TARBALL_URL -P /tmp"
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo tar xf /tmp/$CNI_TARBALL_NAME -C /opt/cni/bin/"


#cat <<EOF | tee /tmp/10-bridge.conf
#{
#    "cniVersion": "0.3.1",
#    "name": "bridge",
#    "type": "bridge",
#    "bridge": "cnio0",
#    "isGateway": true,
#    "ipMasq": true,
#    "ipam": {
#        "type": "host-local",
#        "ranges": [
#          [{"subnet": "${PODS_NET}"}]
#        ],
#        "routes": [{"dst": "0.0.0.0/0"}]
#    }
#}
#EOF
#	scp /tmp/10-bridge.conf $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/
#	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/10-bridge.conf /etc/cni/net.d/10-bridge.conf"
#
#
#cat <<EOF | tee /tmp/99-loopback.conf
#{
#    "cniVersion": "0.3.1",
#    "type": "loopback"
#}
#EOF
#
#	scp /tmp/99-loopback.conf $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/
#	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/99-loopback.conf /etc/cni/net.d/99-loopback.conf"

	#
	# Install kubelet , containerd
	#

	echo "Installing kubelet"

	## Download
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo wget -q $KUBELET_URL -P $KUBERNETES_BIN_DIR"
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo chmod +x $KUBERNETES_BIN_DIR/kubelet"

	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "wget -q --show-progress --https-only --timestamping -P /tmp \
  https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.0.0-beta.0/crictl-v1.0.0-beta.0-linux-amd64.tar.gz \
  https://storage.googleapis.com/kubernetes-the-hard-way/runsc \
  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5/runc.amd64 \
  https://github.com/containernetworking/plugins/releases/download/v0.6.0/cni-plugins-amd64-v0.6.0.tgz \
  https://github.com/containerd/containerd/releases/download/v1.1.0/containerd-1.1.0.linux-amd64.tar.gz"
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "cd /tmp/; sudo chmod +x runc.amd64 runsc; sudo mv runc.amd64 $KUBERNETES_BIN_DIR/runc; sudo mv runsc $KUBERNETES_BIN_DIR/; sudo tar -xvf crictl-v1.0.0-beta.0-linux-amd64.tar.gz -C $KUBERNETES_BIN_DIR/; sudo tar -xvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/; sudo tar -xvf containerd-1.1.0.linux-amd64.tar.gz -C /; sudo mkdir -p /etc/containerd/"

	mkdir -p /tmp/containerd/

cat << EOF | tee /tmp/containerd/config.toml
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""
    [plugins.cri.containerd.untrusted_workload_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runsc"
      runtime_root = "/run/containerd/runsc"
EOF

	scp /tmp/containerd/config.toml $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/config.toml /etc/containerd/"

	## Create systemd service for containerd
cat << EOF | tee /tmp/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

	scp /tmp/containerd.service $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/containerd.service /etc/systemd/system/"

	## Create systemd service for kubelet
cat << EOF | tee "/tmp/$KUBELET_SYSTEMD_SERVICE_PATH"
[Unit]
Description=kubelet

[Service]
ExecStart=${KUBERNETES_BIN_DIR}/kubelet \\
  --kubeconfig=${KUBELET_KUBECONFIG_PATH} \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --network-plugin=cni \\
  --cni-conf-dir=/etc/cni/net.d \\
  --cni-bin-dir=/opt/cni/bin \\
  --register-node=true \\
  --allow-privileged=true \\
  --client-ca-file=${KUBERNETES_CA_CERT_PATH} \\
  --v=2 \\
  --cluster-dns=$KUBE_DNS_SERVICE_IP \\
  --cluster-domain=$CLUSTER_DOMAIN
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

	scp /tmp/$KUBELET_SYSTEMD_SERVICE_PATH $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]}:/tmp/
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo mv /tmp/kubelet.service $KUBELET_SYSTEMD_SERVICE_PATH"

        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl daemon-reload"
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl enable containerd.service"
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl restart containerd.service"
        sleep 5
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl status containerd.service"

        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl enable kubelet.service"
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl restart kubelet.service"
        sleep 5
        ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo systemctl status kubelet.service"

	#needed for helm
	ssh $UBUNTU_USER@${WORKER_PUBLIC_IPS[$i]} "sudo apt-get install socat"
done

kubectl apply -f calico_rbac_apiserver.yaml
kubectl apply -f calico_apiserver.yaml

#!/bin/bash

# check with common.sh file before change variables
CONTROL_PLANE_IP="10.0.0.10"
POD_CIDR="192.168.0.0/16"
KUBERNETES_VERSION="1.25.0"

sudo kubeadm config images pull
sudo apt-get install etcd-client
sudo apt-get install bash-completion

sudo kubeadm init --pod-network-cidr=$POD_CIDR --kubernetes-version=$KUBERNETES_VERSION --apiserver-advertise-address=$CONTROL_PLANE_IP

sudo -i -u vagrant bash << EOF
echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "set ts=2 sw=2 et" >> /home/vagrant/.vimrc
echo "export do=\"--dry-run=client -o yaml\"" >> /home/vagrant/.profile
echo "complete -o default -F __start_kubectl k" >> /home/vagrant/.profile
mkdir -p /home/vagrant/playground
EOF
#!/bin/bash

# mise à jour et installation des packages utils
sudo apt-get update -qq 2>&1 >/dev/null
sudo apt-get install vim -y 2>&1 >/dev/null
sudo apt-get install tree -y 2>&1 >/dev/null
sudo apt-get install jq -y 2>&1 >/dev/null


echo "
10.0.0.10 control-plane
10.0.0.11 node-worker1
10.0.0.12 node-worker2
" >> /etc/hosts
sed -i '/127.0.1.1/d' /etc/hosts

#KUBEADM, CONTAINERD, RUNC, KUBECTL, KUBELET

CONTROL_PLANE_IP="10.0.0.10"
KUBERNETES_VERSION="1.25.0-00"
CONTAINERD_VERSION="1.6.15"

#Create configuration file for containerd
sudo apt-get update && sudo apt-get upgrade -y
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter 
EOF

#Load modules
sudo modprobe overlay 
sudo modprobe br_netfilter

#Set system configurations for Kubernetes networking
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf 
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

#Apply new settings
sudo sysctl --system

#Install containerd
wget https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz
sudo tar Czxvf /usr/local containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz

wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
sudo mv containerd.service /usr/lib/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

#Install runC
wget https://github.com/opencontainers/runc/releases/download/v1.1.1/runc.amd64
sudo install -m 755 runc.amd64 /usr/local/sbin/runc

#Generate default containerd configuration and save to the newly created default file
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

#Restart containerd to ensure new configuration file usage
sudo systemctl restart containerd

#Disable swap
sudo swapoff -a

# keeps the swaf off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo apt-get update -y

#Install dependency packages
sudo apt-get update 
sudo apt-get install -y apt-transport-https curl

#Download and add GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

#Add Kubernetes to repository list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF


#update packages and Install Kubernetes packages (Note: If you get a `dpkg lock` message, just wait a minute or two before trying the command again):
sudo apt-get update 
sudo apt-get install -qy kubelet=$KUBERNETES_VERSION kubeadm=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION
sudo apt-mark hold kubelet kubeadm kubectl
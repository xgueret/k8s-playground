# Finalize The Installation

> Note: I think the following actions should be automated



## :eyes: Relevant Documentation

:point_right: https://docs.oracle.com/fr-fr/iaas/Content/ContEng/Tasks/contengsettingupcalico.htm

:point_right: https://docs.tigera.io/calico/3.25/getting-started/kubernetes/quickstart





## :construction_worker:Let's get our hands dirty 


```shell
vagrant up
```

```shell
vagrant ssh control-plane
```



create key to ssh into worker1 and worker2 from the controle-plane node

```shell
ssh-keygen -t rsa -b 4096
```

```shell
ssh-copy-id node-worker1
```

```shell
ssh-copy-id node-worker2
```

Set **kubectl** access:

```shell
mkdir -p $HOME/.kube && \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Install CNI(*Container Network Interface*) : Calico Network Add-On

```shell
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml
```



Wait until all is done

```shell
kubectl get pod -n kube-system -w | grep calico
```



Install Metrics Server

```shell
kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml
```



Join the Worker Nodes to the Cluster

```shell
export JOIN=$(kubeadm token create --print-join-command)
```



:point_right: on each worker `ssh node-worker1`  `ssh node-worker2`

```shell
ssh node-worker1 sudo $JOIN
```

```shell
ssh node-worker2 sudo $JOIN
```

verify

```shell
k get nodes -w
```



:point_right: ssh into all the nodes and execute this command even the control plane node

```shell
ssh node-worker1 sudo crictl config \
--set runtime-endpoint=unix:///run/containerd/containerd.sock \
--set image-endpoint=unix:///run/containerd/containerd.sock
```

```shell
ssh node-worker2 sudo crictl config \
--set runtime-endpoint=unix:///run/containerd/containerd.sock \
--set image-endpoint=unix:///run/containerd/containerd.sock
```



The installation is complete now, enjoy :tada:

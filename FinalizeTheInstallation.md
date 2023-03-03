# Finalize The Installation



```shell
cd <in the working directory>
```



How to launch your playground environment ?


```shell
vagrant up
```

```shell
vagrant ssh control-plane
```

```shell
ssh-keygen -t rsa -b 4096
ssh-copy-id node-worker1
ssh-copy-id node-worker2
```

Set **kubectl** access:

```shell
mkdir -p $HOME/.kube && \
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && \
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Install CNI(*Container Network Interface*) : Calico Network Add-On

https://docs.oracle.com/fr-fr/iaas/Content/ContEng/Tasks/contengsettingupcalico.htm

comment installer calico : https://docs.tigera.io/calico/3.25/getting-started/kubernetes/quickstart

```shell
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml -O
kubectl apply -f calico.yaml
```



**Wait until all is done**

```shell
kubectl get pod -n kube-system -w | grep calico
```



**Install Metrics Server**

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
ssh node-worker2 sudo $JOIN
# verify
k get nodes -w
```

:point_right: ssh into all the nodes and execute this command even the control plane node

```shell
sudo crictl config \
--set runtime-endpoint=unix:///run/containerd/containerd.sock \
--set image-endpoint=unix:///run/containerd/containerd.sock
```

install Inginx ingress controller

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/baremetal/deploy.yaml
```



**check the version**

```shell
POD_NAMESPACE=ingress-nginx
POD_NAME=$(kubectl get pods -n $POD_NAMESPACE -l app.kubernetes.io/name=ingress-nginx --field-selector=status.phase=Running -o name)
kubectl exec $POD_NAME -n $POD_NAMESPACE -- /nginx-ingress-controller --version
```


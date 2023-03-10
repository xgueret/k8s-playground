# Building our kubernetes cluster with kubeadm step by step



Setting up our infrastructure


```shell
vagrant up
```



go to the control-plane

```shell
vagrant ssh control-plane
```



## :microscope: Hands on labs

:point_right:  [How to build step by step a Kubernetes Cluster](../Labs/How_to_build_a_Kubernetes_Cluster.md)

:point_right: [How to install helm](../Labs/How_To_install_helm.md)

:point_right: How to install a basic configuration of ingress with nginx controller :construction:



check the installation is ok

```shell
helm version
```



## :recycle: Cleaning the workspace

```shell
vagrant destroy -f
```


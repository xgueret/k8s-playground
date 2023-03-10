# How To Setup Jenkins On Kubernetes Cluster using Helm | Running Jenkins in Kubernetes Cluster



## :eyes: Relevant Documentation

:point_right: [installation de helm](https://helm.sh/fr/docs/intro/install/) :star:

:point_right: [helm completion bash](https://helm.sh/docs/helm/helm_completion_bash/) 

:point_right: [Installer Jenkins](https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins)

:point_right: [official documentation installing jenkins with helm](https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins-with-helm-v3)



## :construction_worker:Let's get our hands dirty 

```shell
vagrant up
vagrant ssh control-plane
```



check

```shell
helm version
version.BuildInfo{Version:"v3.11.1", GitCommit:"293b50c65d4d56187cd4e2f390f0ada46b4c4737", GitTreeState:"clean", GoVersion:"go1.18.10"}
```



on control-plane

```shell
mkdir labs
cd labs
```



Create a persistent volume

```shell
wget https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-volume.yaml -O jenkins-volume.yaml
```



**:warning: on each worker node**

```shell
sudo mkdir -p /home/vagrant/playground/jenkins-volume
sudo chown -R 1000:1000 /home/vagrant/playground/jenkins-volume
```



control-plane

```shell
kubectl apply -f jenkins-volume.yaml
```



Create a service account

```shell
wget https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml -O jenkins-sa.yaml
```

```shell
kubectl apply -f jenkins-sa.yaml
```

```shell
wget https://raw.githubusercontent.com/jenkinsci/helm-charts/main/charts/jenkins/values.yaml -O jenkins-values.yaml
```

make the changes as indicated in the jenkins-values file.

then run the following commands:

```shell
chart=jenkinsci/jenkins && \
helm install jenkins -n jenkins -f jenkins-values.yaml $chart
```

*(i) info*

```
NAME: jenkins
LAST DEPLOYED: Fri Mar  3 09:03:57 2023
NAMESPACE: jenkins
STATUS: deployed
REVISION: 1
NOTES:
1. Get your 'admin' user password by running:
  kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
2. Get the Jenkins URL to visit by running these commands in the same shell:
  echo http://127.0.0.1:8080
  kubectl --namespace jenkins port-forward svc/jenkins 8080:8080

3. Login with the password from step 1 and the username: admin
4. Configure security realm and authorization strategy
5. Use Jenkins Configuration as Code by specifying configScripts in your values.yaml file, see documentation: http://127.0.0.1:8080/configuration-as-code and examples: https://github.com/jenkinsci/configuration-as-code-plugin/tree/master/demos

For more information on running Jenkins on Kubernetes, visit:
https://cloud.google.com/solutions/jenkins-on-container-engine

For more information about Jenkins Configuration as Code, visit:
https://jenkins.io/projects/jcasc/


NOTE: Consider using a custom image with pre-installed plugins
```

check

```shell
kubectl get pods -n jenkins
```



## :recycle: Cleaning the workspace

```shell
helm uninstall jenkins -n jenkins
k delete -f jenkins-volume.yaml
k delete -f jenkins-sa.yaml
```

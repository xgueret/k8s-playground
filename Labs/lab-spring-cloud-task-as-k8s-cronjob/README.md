# LAB: Spring Cloud Task As K8S cronjob



## :eyes: Relevant Documentation

:point_right: [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)

:point_right: [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)

```shell
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │                                   OR sun, mon, tue, wed, thu, fri, sat
# │ │ │ │ │
# * * * * *
```

:point_right: [Spring Cloud Task Reference Guide](https://docs.spring.io/spring-cloud-task/docs/current/reference/html/)

:point_right: [Spring Initialzr](https://start.spring.io/)

:point_right: [Spring Boot Docker](https://spring.io/guides/topicals/spring-boot-docker/)

 

> **Note** : A another approach with [Spring Cloud Data Flow](https://dataflow.spring.io/) 
>
> *Spring Cloud Data Flow is **an open-source toolkit that can deploy streaming and batch data pipelines on Cloud Foundry**. The data pipelines are composed of Spring Cloud Stream or Spring Cloud Task applications. A streaming pipeline DSL makes it easy to specify which apps to deploy and how to connect outputs and inputs.*



## A very simple Spring Cloud Task Application running as CronJob in Kubernetes



```shell
cd helloworld
```



Build and run the application:

```shell
./mvnw clean package
```

```shell
./mvnw clean spring-boot:run
```



the Dockerfile is located at the root of the project

```dockerfile
FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```



building an image with the following command:

```shell
docker build --build-arg JAR_FILE=target/*.jar -t xgtlabs-spring-cloud-task/helloworld:1.0.0 .
```

> **Note**: use your own tag instead off **`xgtlabs-spring-cloud-task/helloworld:1.0.0`**



Test the docker image

```shell
docker run --name mytest -d xgtlabs-spring-cloud-task/helloworld
```

```shell
docker logs <container id>
```

clean

```shell
docker rm mytest
```



 push the image on your docker hub account

```
docker login
```



tag your image

```shell
docker tag xgtlabs-spring-cloud-task/helloworld:1.0.0 <your dockerhub account>/spring-cloud-task-hello:1.0
```

```shell
docker push <your dockerhub account>/spring-cloud-task-hello:1.0
```

Create Container From Custom Docker Hub Images:

```shell
docker run --name mytest -d <your dockerhub account>/spring-cloud-task-hello:1.0
```

```shell
docker logs <container id>
```



Log in to the control plane node. 

```shell
vagrant ssh control-plane         
```



Create a CronJob that will run the Job task every minutes

```yaml
cat <<EOF | tee my-cronjob.yml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: my-cronjob
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: mysimpletask
            image: <your dockerhub account>/spring-cloud-task-hello:1.0
          restartPolicy: Never
      backoffLimit: 4
      activeDeadlineSeconds: 120
EOF
```

```shell
kubectl apply -f my-cronjob.yml
```



:recycle: Cleaning the workspace

```shell
kubectl delete -f my-cronjob.yml
```


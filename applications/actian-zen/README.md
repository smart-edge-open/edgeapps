```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Actian Corporation
```
# Actian Zen Overview
Actian Zen Edge Data Management is a single, secure, modular, and scalable solution that embeds in or bundles with applications for remote/branch, mobile, and IoT data processing and analytics support. Zen provides SQL and NoSQL access for any type of data from within most popular programming languages running on Windows (IoT Core, Desktop, Server), Linux (embedded and standard), MacOS running on Intel platforms and running on iOS/Android for mobile.

For more information on Actian Zen please visit the [Actian Zen product website](https://www.actian.com/data-management/zen-embedded-database/).

# Application Overview
Two helm charts are provided in the 'helm-charts' directory to assist with Zen deployments in an Intel® Smart Edge Open Developer Experience Kit environment: an Actian Zen database chart and a sample application chart. The 'actianzen' chart will deploy the Actian Zen database as a service in the Intel® Smart Edge Open Developer Experience Kit Kubernetes environment with a 30 day trial license. The 'zensample' chart deploys a simple ODBC web application that communicates with a Zen database. The Zen sample chart has the Zen database chart configured as a dependency which will deploy both the Zen database and the sample application containers when installed.

## Deploying the Zen Database and Sample Application

### Loading Docker Images
A prerequisite for deploying the Zen database and sample application is to "pre-pull" the docker container images onto the edge nodes. To obtain the Zen database container and the sample application container please go to https://github.com/ActianCorp/ActianZen-OpenNESS to download the archived images.

Once downloaded and copied to the edge nodes, the Zen database and sample application container images can be loaded using the following commands:
```shell
docker image load -i actianzen-<release>.tar.gz
docker image load -i zensample-<release>.tar.gz
```

### Installing Actian Zen using Helm
It is recommended to create a Kubernetes namespace for deploying Zen containers. The following example creates a namespace called "zen":
```shell
kubectl create namespace zen
```
Run the following commands to deploy an instance of the Zen database through helm; note the use of the '-n' option to specify the namespace:
```shell
cd ./helm-charts/actianzen
helm install -n zen actianzen .
```

### Installing The Zen Sample Application using Helm
The creation of a Kubernetes namespace is also recommended for deploying the Zen sample chart. Additionally, the Zen sample chart has a dependency on the Actian Zen chart. To satisfy this dependency you will need to run the following commands:
```shell
cd ./helm-charts/zensample
helm dep update
```
This will create an `actianzen-***.tgz` package under the `zensample/charts` directory, which is derived from the local chart `./helm-charts/actianzen`.
The chart can be installed once the dependency is satisfied, which will deploy both an Actian Zen container and the sample application container:
```shell
helm install -n zen zensample .
```
Instructions on accessing the web application will appear in the terminal after a successful deployment
```shell
$ helm install -n zen zensample .
NAME: zensample
LAST DEPLOYED: Mon Sep 28 12:53:15 2020
NAMESPACE: zen
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Installed zensample.
The release is named zensample.
Get the application URL by running these commands:
  export NODE_PORT=$(kubectl get --namespace zen -o jsonpath="{.spec.ports[0].nodePort}" services zensample)
  export NODE_IP=$(kubectl get nodes --namespace zen -o jsonpath="{.items[0].status.addresses[0].address}")
  echo http://$NODE_IP:$NODE_PORT
```

## Uninstalling Actian Zen
```shell
helm uninstall -n zen actianzen
helm uninstall -n zen zensample
```

## Additional Information
* [General Actian Zen Information](https://www.actian.com/data-management/zen-embedded-database/)
* [Zen Application Development Tutorials](https://zendocs.actian.com/)
* [Zen Documentation Library](https://docs.actian.com/zen/v14/)
* [YouTube Tutorials Playlist](https://www.youtube.com/playlist?list=PLdxh0pjAEDMtro-Cek3gWW3AvTlkFfloL)
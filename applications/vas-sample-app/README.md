```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

# Video Analytics Services Sample Application in OpenNESS

- [Introduction](#introduction)
  - [Directory Structure](#directory-structure)
- [Quick Start](#quick-start)
  - [Sample App Deployment](#sample-app-deployment)
  - [Sample App Results](#sample-app-results)

## Introduction

This sample application demonstrates the Video Analytics Services (VAS) consumer sample application deployment and execution on the OpenNESS edge platform with VAS enabled.
For more information on VAS itself, please see [OpenNESS Video Analytics Services](https://github.com/otcshare/specs/blob/master/doc/applications/openness_va_services.md).


### Directory Structure
- `/cmd` : Application source files.
- `/build` : Build scripts.
- `/deployments` : Helm Charts and K8s yaml files.


## Quick Start
To build  the sample application container image, run the following command from the sample application folder:

```sh
./build/build-image.sh
```

After building the image, you can push it directly to the Harbor Registry on the controller with the following command:

```sh
docker push <controller_ip>:30003/intel/vas-cons-app:1.0
```

The image can also be built and stored directly on the edgenode.

> **Note**: If the application image is pushed to the Harbor Registry on the controller, you will need to edit the entry ```repository``` in ```deployments/helm/values.yaml``` or ```deployments/yaml/vas-cons-app.yaml``` to the IP address of the Harbor Registry before deploying the application.

### Sample App Deployment

- Make sure the sample application images are built and reachable by running ```docker image list | grep vas-cons-app``` on the edgenode.
- Two methods are available for deploying the sample application on the edgenode:
  - Use the command ```kubectl apply -f vas-cons-app.yaml``` from the ```deployments/yaml``` folder.
  - Use Helm to install the application using the files in the ```deployments/helm``` folder.


### Sample App Results

1. Check whether the application pod is successfully deployed.
```sh
# kubectl get pods -A | grep vas-cons-app
default       vas-cons-app-7f8bf7c978-csfwj -c vas-cons-app        0/1     Completed   0          30h
```

2. Check the pod's logs, results should look similar to the following:

```sh
# kubectl logs vas-cons-app-7f8bf7c978-csfwj -c vas-cons-app
2020/06/29 01:37:25 Video-analytics-service Consumer Started
2020/06/29 01:37:25 CSR Started
2020/06/29 01:37:25 CSR creating certificate
2020/06/29 01:37:25 CSR POST /auth
2020/06/29 01:37:25 Service Discovery Started
2020/06/29 01:37:25 Discoverd serive:
2020/06/29 01:37:25     URN.ID:        producer
2020/06/29 01:37:25     Description:   Video Analytics Service
2020/06/29 01:37:25     EndpointURI:   http://analytics-gstreamer:8080
2020/06/29 01:37:25 Starting POST Request:http://analytics-gstreamer:8080/pipelines/emotion_recognition/1
2020/06/29 01:37:25 Pipeline Instance Created: 1

2020/06/29 01:37:25 {
  "avg_fps": 0,
  "elapsed_time": 0.005330085754394531,
  "id": 1,
  "start_time": 1593394645.8940227,
  "state": "QUEUED"
}

2020/06/29 01:37:35 {
  "avg_fps": 133.54638124371084,
  "elapsed_time": 8.90360951423645,
  "id": 1,
  "start_time": 1593394645.8940227,
  "state": "COMPLETED"
}
```

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
For more information on VAS itself, please see [OpenNESS Video Analytics Services](https://github.com/open-ness/specs/blob/master/doc/applications/openness_va_services.md).

## Directory Structure
- `/cmd` : Application source files.
- `/build` : Build scripts.
- `/deployments` : Helm Charts and Kubernetes YAML specs files.

## Getting Started
To build  the sample application container image, run the following command from the sample application folder:

```sh
./build/build-image.sh
```

After building the image, you can push it directly to the Harbor Registry on the controller with the following command:

```sh
docker tag vas-cons-app:1.0 <controller_ip>:30003/intel/vas-cons-app:1.0
docker push <controller_ip>:30003/intel/vas-cons-app:1.0
```

The image can also be built and stored directly on the edgenode.

> **NOTE**: If the application image is pushed to the Harbor Registry on the controller, you will need to uncomment and edit the entry `registry` in Helm chart's [values.yaml](./deployments/helm/values.yaml) file or in the [YAML specs](./deployments/yaml/vas-cons-app.yaml) file to the IP address of the Harbor Registry before deploying the application.

### Application Deployment using Helm

1. Make sure that the sample application Docker image is built and available in the system
    ```shell
    docker image list | grep vas-cons-app
    ```

2. Two methods are available for deploying the Video Analytics Services sample application:

    **Through the Helm chart:**
    ```shell
    helm install vas-cons-app deployments/helm/
    ```

    **Or, through the Kubernetes native YAML specs:**
    ```shell
    kubectl apply -f deployments/yaml/vas-cons-app.yaml
    ```

### Application Certificate Approval

InitContainer of the Sample App issues CertificateSigningRequest (csr), which needs to be approved by the cluster admin:

```shell
kubectl certificate approve vas-cons-app
```

List of Certificate Signing Requests can be checked with:

```shell
$ kubectl get csr
NAME            AGE     SIGNERNAME                REQUESTOR                                     CONDITION
vas-cons-app    6m41s   openness.org/certsigner   system:serviceaccount:default:vas-cons-app    Approved,Issued
```

### Application Results

1. Check whether the application pod is successfully deployed.
    ```shell
    $ kubectl get pods | grep vas-cons-app
    vas-cons-app-7b8c9f87d8-79vnq          1/1     Running   0          39s
    ```

2. Check the pod's logs, results should look similar to the following:
    ```shell
    $ kubectl logs -f vas-cons-app-7b8c9f87d8-79vnq
    go: downloading github.com/pkg/errors v0.9.1
    2020/12/17 21:01:31 Video-analytics-service Consumer Started
    2020/12/17 21:01:31 Create Encrypted client
    2020/12/17 21:01:31 Loading certificate and key
    2020/12/17 21:01:31 &http.Client{Transport:(*http.Transport)(0xc000014640), CheckRedirect:(func(*http.Request, []*http.Request) error)(nil), Jar:http.CookieJar(nil), Timeout:0}
    2020/12/17 21:01:31 Service Discovery Started
    2020/12/17 21:01:31 Discovered service:
    2020/12/17 21:01:31  -> URN.ID:        analytics-ffmpeg-xeon
    2020/12/17 21:01:31  -> URN.Namespace: default
    2020/12/17 21:01:31  -> Description:   Video Analytics Service
    2020/12/17 21:01:31  -> EndpointURI:   http://analytics-ffmpeg:8080
    2020/12/17 21:01:31 Sending request for pipeline emotion_recognition/1
    2020/12/17 21:01:31 Starting POST Request:  http://analytics-ffmpeg:8080/pipelines/emotion_recognition/1
    2020/12/17 21:01:31 Starting status check:  http://analytics-ffmpeg:8080/pipelines/emotion_recognition/1/1/status
    2020/12/17 21:01:31 {
    avg_fps: 0.000000,
    elapsed_time: 0.002553
    id: 1
    start_time: 1608238891.518393
    state: QUEUED
    }
    2020/12/17 21:01:41 Starting status check:  http://analytics-ffmpeg:8080/pipelines/emotion_recognition/1/1/status
    2020/12/17 21:01:41 {
    avg_fps: 307.000000,
    elapsed_time: 5.546350
    id: 1
    start_time: 1608238891.518393
    state: COMPLETED
    }
    2020/12/17 21:01:41 Sending request for pipeline object_detection/1
    2020/12/17 21:01:41 Starting POST Request:  http://analytics-ffmpeg:8080/pipelines/object_detection/1
    2020/12/17 21:01:41 Starting status check:  http://analytics-ffmpeg:8080/pipelines/object_detection/1/2/status
    2020/12/17 21:01:41 {
    avg_fps: 0.000000,
    elapsed_time: 0.002460
    id: 2
    start_time: 1608238901.528120
    state: QUEUED
    }
    2020/12/17 21:01:51 Starting status check:  http://analytics-ffmpeg:8080/pipelines/object_detection/1/2/status
    2020/12/17 21:01:51 {
    avg_fps: 200.000000,
    elapsed_time: 6.552458
    id: 2
    start_time: 1608238901.528120
    state: COMPLETED
    }
    2020/12/17 21:01:51 Discovered service:
    2020/12/17 21:01:51  -> URN.ID:        analytics-gstreamer-xeon
    2020/12/17 21:01:51  -> URN.Namespace: default
    2020/12/17 21:01:51  -> Description:   Video Analytics Service
    2020/12/17 21:01:51  -> EndpointURI:   http://analytics-gstreamer:8080
    2020/12/17 21:01:51 Sending request for pipeline emotion_recognition/1
    2020/12/17 21:01:51 Starting POST Request:  http://analytics-gstreamer:8080/pipelines/emotion_recognition/1
    2020/12/17 21:01:51 Starting status check:  http://analytics-gstreamer:8080/pipelines/emotion_recognition/1/1/status
    2020/12/17 21:01:51 {
    avg_fps: 0.000000,
    elapsed_time: 0.001916
    id: 1
    start_time: 1608238911.618644
    state: QUEUED
    }
    2020/12/17 21:02:01 Starting status check:  http://analytics-gstreamer:8080/pipelines/emotion_recognition/1/1/status
    2020/12/17 21:02:01 {
    avg_fps: 322.830249,
    elapsed_time: 3.683640
    id: 1
    start_time: 1608238911.618644
    state: COMPLETED
    }
    2020/12/17 21:02:01 Sending request for pipeline object_detection/1
    2020/12/17 21:02:01 Starting POST Request:  http://analytics-gstreamer:8080/pipelines/object_detection/1
    2020/12/17 21:02:01 Starting status check:  http://analytics-gstreamer:8080/pipelines/object_detection/1/2/status
    2020/12/17 21:02:01 {
    avg_fps: 0.000000,
    elapsed_time: 0.001966
    id: 2
    start_time: 1608238921.642088
    state: QUEUED
    }
    2020/12/17 21:02:11 Starting status check:  http://analytics-gstreamer:8080/pipelines/object_detection/1/2/status
    2020/12/17 21:02:11 {
    avg_fps: 234.326014,
    elapsed_time: 5.074890
    id: 2
    start_time: 1608238921.642088
    state: COMPLETED
    }
    ```

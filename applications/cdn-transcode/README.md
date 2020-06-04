```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

# CDN Transcode Sample Application on OpenNESS Platform

CDN Transcode is a sample application that is built on top of the Open Visual Cloud software stacks for media processing and analytics. 

- [Building the CDN Transcode Sample Application](#building-the-cdn-transcode-sample-application)
- [Onboarding the CDN Transcode Sample in the OpenNESS Platform](#onboarding-the-cdn-transcode-sample-in-the-openness-platform)
  - [Option 1](#option-1)
  - [Option 2](#option-2)
- [Remove the CDN Transcode Sample Application from OpenNESS platform](#remove-the-cdn-transcode-sample-application-from-openness-platform)

Clone the edgeapps repo. The scripts required for preparing the OpenNESS setup for on-boarding the CDN transcode sample application is available under "applications/cdn-transcode" folder in the edgeapps repo.

## Building the CDN Transcode Sample Application

1. Clone the CDN Transcode Sample Application from [GitHub](https://github.com/OpenVisualCloud/CDN-Transcode-Sample) on to the OpenNESS Master.

2. Build the CDN Transcode Application.

> **Note**: "ovc-clone-compile.sh" script can be used to clone and build the CDN Transcode Sample Application. This script also takes care of passing the docker registry (in OpenNESS Master) for storing the docker images. Run the following to clone and build as below
```
./ovc-clone-compile.sh
```
## Onboarding the CDN Transcode Sample in the OpenNESS Platform

The CDN Transcode sample can be on-boarded on an OpenNESS platform using Helm Chart. Before installing the chart, pre-installation step need to be run, to prepare the volumes and certificate. The pre-installation step can be run manually (option-1 below) or directly as post renderer while installing the helm chart (option-2 below).

### Remove the Network Policy
> **NOTE**: At the time of writing this guide, there was no [Network Policy for Kubernetes](https://kubernetes.io/docs/concepts/services-networking/network-policies/) defined yet for the CDN Transcode Sample application. So, it is advised to remove the default OpenNESS network policies using this command:
```shell
kubectl delete netpol block-all-ingress cdi-upload-proxy-policy
```
### Option 1
Run the pre-installation separately first followed by helm installation.
#### Pre install
This step prepares the OpenNESS platform before on-boarding the CDN Transcode Sample Application.
- Creates the self signed certificate
- Creates the volumes for storing the videos.
```shell
./pre-install.sh
```

#### Install the CDN Transcode Sample Application services

Helm is used for deploying the application. Run the following command to install the CDN Transcode Sample Application,
```
helm install cdn-transcode ./CDN-Transcode-Sample/deployment/kubernetes/helm/cdn-transcode/
```
### Option 2
The pre-installation step is run as part of Helm installation during post rendering of the chart.
```
helm install cdn-transcode ./CDN-Transcode-Sample/deployment/kubernetes/helm/cdn-transcode/ --post-renderer ./post-render.sh
```

The above steps will deploy the application on the OpenNESS node.
> **NOTE** These steps are tested from the OpenNESS master with a single OpenNESS edge Node only.

Check the running pods as below,
```
# kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
cdn-service-54f5976fd5-55p7v        1/1     Running   0          68m
kafka-service-7b9db4b84f-m89j5      1/1     Running   6          41m
live-service-0-5f5cb68578-nh89d     1/1     Running   5          68m
redis-service-6cc6d7bdcc-n74kt      1/1     Running   0          68m
vod-service-7784f6f665-96spn        1/1     Running   0          68m
vod-service-7784f6f665-bffvf        1/1     Running   0          68m
zookeeper-service-68bc89fb9-7qb5x   1/1     Running   0          68m
```
> **NOTE** Please refer to [GitHub](https://github.com/OpenVisualCloud/CDN-Transcode-Sample) for further details on testing the CDN Transcode Sample Application.

## Remove the CDN Transcode Sample Application from OpenNESS platform
To remove the CDN Transcode Sample Application services follow the below steps,

```
helm delete cdn-transcode
./clean.sh
```


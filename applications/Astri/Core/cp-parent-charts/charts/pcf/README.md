```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


## Overview
This manual describes how to install PCF using Helm chart and also illustrates the corresponding configurations.

ASTRI 5G SA Characteristics
* 3GPP Release 15 compliance
* Can be evolved to comply 3GPP Release 16
* Service Base Architecture
* Support of Standalone (SA) 5G Network
* Suitable for vertical and enterprise market
* Suitable for edge deployment
* General purpose x86 platform hardware
* Roaming Not Supported


## Prerequisites

**1.Recommend Hardware Requirements for Control-Plane Network Functions Containers:**
 * 16 Core CPU
 * 32Gi Memory

**2.Software Requirements:**
 * Ubuntu 18.04
 * Kubernets >=v 1.17
 * Helm >= v3.1


## Installation

1. Load PCF image from tar file:
```
docker load -i PCF-image-v22.03-rc0.tar.gz
```

2. Install the PCF Helm Chart:

    Control Plane NFS Helm chart is located at **charts/cp-parent-charts/charts/**

    ```
    cd charts/cp-parent-charts/charts/

    helm install pcf pcf/
    ```
    Expected Output:

        NAME: PCF
        LAST DEPLOYED: Wed Jul 28 22:02:55 2021
        NAMESPACE: default
        STATUS: deployed
        REVISION: 1
        TEST SUITE: None


## Uninstallation
```
helm uninstall pcf
```
Expected Output:

    release "pcf" uninstalled

## Configuration

| Parameter                          | Description                                            | Default                                          |
|------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| `enabled`                          | Parameters to define if PCF should be installed        | `true`
| `replicaCount`                     | Numbers of container to be deployed                    | `1`
| `image.repository`                 | Docker image name                                      | `astri.org/5g/pcf`
| `image.tag`                        | Docker image tag for PCF                               | `v22.03-rc0`
| `image.pullPolicy`                 | The Kubernetes imagePullPolicy value                   | `IfNotPresent`
| `tolerations`                      | Node tolerations for server scheduling to nodes with taints  | `[]`
| `podIP`                            | podIP is used to configure the IP address of Pod's calico network interface | `10.245.216.129`
| `networkInterfaces`                | 5G SBI Network Interfaces Configurations for PCF       | `[]`
| `networkInterfaces.n7Http2Server`  | Local N7 Interface Address                             | `10.245.216.129`
| `networkInterfaces.n7Http2ServerPort`    | Local N7 Interface Port                          | `7081`
| `networkInterfaces.n7Http2Client`  | Local N7 Interface Client Address                      | `10.245.216.129`
| `networkInterfaces.n7Http2ClientPort`    | Local N7 Interface Client Port                   | `7082`
| `networkInterfaces.n15Http2Server`  | Local N15 Interface Address                           | `10.245.216.129`
| `networkInterfaces.n15Http2ServerPort`    | Local N15 Interface Port                        | `7080`
| `nodeSelector`                     | PCF Node selector for pod assignment                   | `controller`
| `service`                          | PCF Kubernetes service configurations                  | `[]`
| `service.annotations`              | PCF service annotation                                 | `[]`
| `service.clusterIP`                | Cluster internal IP of PCF Service                     | `[]`
| `service.externalIPs`              | List of IP addresses that PCF service exposed          | `[]`
| `service.name_n7`                  | Name for Kubernetes service of N7                      | `n7`
| `service.name_n15`                 | Name for Kubernetes service of N15                     | `n15`
| `service.type`                     | Configuration of PCF service types. Choosing this value makes the Service only reachable from within the cluster.   | `ClusterIP`
| `service.servicePort_n7`           | Service port for N7                                    | `7081`
| `service.servicePort_n15`          | Service port for N15                                   | `7080`
| `resources.limits.cpu`             | Number of CPU core limited                             | `250m`
| `resources.limits.memory`          | Memory limited in mebibyte                             | `256Mi`
| `resources.requests.cpu`           | Number of CPU core requested                           | `250m`
| `resources.requests.memory`        | Memory requested in mebibyte                           | `256Mi`
| `terminationGracePeriodSeconds`    | Pod's grace period of termination                      | `30`
| `licenseSecret`                    | License secret name                                    | `license-controller`


## Contact

Please contact ASTRI for sales information.

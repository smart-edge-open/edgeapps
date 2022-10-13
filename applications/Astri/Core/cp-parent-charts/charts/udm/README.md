```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


## Overview
This manual describes how to install UDM using Helm chart and also illustrates the corresponding configurations.

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

1. Load UDM image from tar file:
```
docker load -i UDM-image-v22.03-rc0.tar.gz
```

2. Install the UDM Helm Chart:

    Control Plane NFS Helm chart is located at **charts/cp-parent-charts/charts/**

    ```
    cd charts/cp-parent-charts/charts/

    helm install udm udm/
    ```
    Expected Output:

        NAME: udm
        LAST DEPLOYED: Wed Jul 28 22:02:55 2021
        NAMESPACE: default
        STATUS: deployed
        REVISION: 1
        TEST SUITE: None


## Uninstallation
```
helm uninstall udm
```
Expected Output:

    release "udm" uninstalled

## Configuration

| Parameter                          | Description                                            | Default                                          |
|------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| `enabled`                          | Parameters to define if UDM should be installed        | `true`
| `replicaCount`                     | Numbers of container to be deployed                    | `1`
| `image.repository`                 | Docker image name                                      | `astri.org/5g/udm`
| `image.tag`                        | Docker image tag for UDM                               | `v22.03-rc0`
| `image.pullPolicy`                 | The Kubernetes imagePullPolicy value                   | `IfNotPresent`
| `tolerations`                      | Node tolerations for server scheduling to nodes with taints  | `[]`
| `podIP`                            | podIP is used to configure the IP address of Pod's calico network interface | `10.245.216.131`
| `networkInterfaces`                | 5G SBI Network Interfaces Configurations for UDM       | `[]`
| `networkInterfaces.Http2Server`    | Local HTTP2 Server Address                             | `10.245.216.131`
| `networkInterfaces.Http2ServerPort`| Local HTTP2 Server Port                                | `3123`
| `networkInterfaces.Http2Client`    | Local HTTP2 Client Address                             | `10.245.216.131`
| `networkInterfaces.Http2ClientPort`| Local HTTP2 Client Port                                | `3122`
| `networkInterfaces.udrClient`      | Local UDR Client Address                               | `10.245.216.131`
| `networkInterfaces.udrClientPort`  | Local UDR Client Port                                  | `3121`
| `networkInterfaces.udrServer`      | UDR Server Address                                     | `10.245.216.111`
| `networkInterfaces.udrServerPort`  | UDR Server Port                                        | `80`
| `networkInterfaces.udrNotiServer`  | UDR Noti Server Address                                | `10.245.216.131`
| `networkInterfaces.udrNotiServerPort`  | UDR Noti Server Port                               | `3124`
| `nodeSelector`                     | UDM Node selector for pod assignment                   | `controller`
| `service`                          | UDM Kubernetes service configurations                  | `[]`
| `service.annotations`              | UDM service annotation                                 | `[]`
| `service.clusterIP`                | Cluster internal IP of UDM Service                     | `[]`
| `service.externalIPs`              | List of IP addresses that UDM service exposed          | `[]`
| `service.name`                     | Name of the Kubernetes service                         | `n13n8n10`
| `service.type`                     | Configuration of UDM service types. Choosing this value makes the Service only reachable from within the cluster.        | `ClusterIP`
| `service.servicePort`              | Service port for N8, N10 and N13                       | `3123`
| `resources.limits.cpu`             | Number of CPU core limited                             | `250m`
| `resources.limits.memory`          | Memory limited in mebibyte                             | `256Mi`
| `resources.requests.cpu`           | Number of CPU core requested                           | `250m`
| `resources.requests.memory`        | Memory requested in mebibyte                           | `256Mi`
| `terminationGracePeriodSeconds`    | Pod's grace period of termination                      | `30`
| `licenseSecret`                    | License secret name                                    | `license-controller`

## Contact

Please contact ASTRI for sales information.

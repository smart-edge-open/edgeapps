```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Astri Corporation
```


## Overview
This manual describes how to install SMF using Helm chart and also illustrates the corresponding configurations.

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

1. Load SMF image from tar file:
```
docker load -i SMF-image-v22.03-rc0.tar.gz
```

2. Install the SMF Helm Chart:

    Control Plane NFS Helm chart is located at **charts/cp-parent-charts/charts/**

    ```
    cd charts/cp-parent-charts/charts/

    helm install smf smf/
    ```
    Expected Output:

        NAME: smf
        LAST DEPLOYED: Wed Jul 28 22:02:55 2021
        NAMESPACE: default
        STATUS: deployed
        REVISION: 1
        TEST SUITE: None


## Uninstallation
```
helm uninstall smf
```
Expected Output:

    release "SMF" uninstalled

## Configuration

| Parameter                          | Description                                            | Default                                          |
|------------------------------------|--------------------------------------------------------|--------------------------------------------------|
| `enabled`                          | Parameters to define if SMF should be installed        | `true`
| `replicaCount`                     | Numbers of container to be deployed                    | `1`
| `image.repository`                 | Docker image name                                      | `astri.org/5g/smf`
| `image.tag`                        | Docker image tag for SMF                               | `v22.03-rc0`
| `image.pullPolicy`                 | The Kubernetes imagePullPolicy value                   | `IfNotPresent`
| `networks`                         | Kubernetes pod network resources configuration, set enabled: false to use default CNI option (e.g. calico, flannel)                     | `[]`
| `networks.enabled`                 | Parameters to define if  network resources should be used            | `false`
| `networks.name`                    | Name of the  network resource.                   | `[]`
| `tolerations`                      | Node tolerations for server scheduling to nodes with taints  | `[]`
| `podIP`                            | podIP is used to configure the IP address of Pod's calico network interface | `10.245.216.130`
| `networkInterfaces`                | 5G SBI Network Interfaces Configurations for SMF       | `[]`
| `networkInterfaces.n4PfcpServer`  | Local PFCP Server Address                               | `10.245.216.130`
| `networkInterfaces.n4PfcpServerPort`    | Local PFCP Server Port                            | `8806`
| `networkInterfaces.n11Http2Server`  | Local N11 Interface Server Address                    | `10.245.216.130`
| `networkInterfaces.n11Http2ServerPort`    | Local N11 Interface Server Port                 | `3123`
| `networkInterfaces.n11Http2Client`  | Local N11 Interface Client Address                    | `10.245.216.130`
| `networkInterfaces.n11Http2ClientPort`    | Local N11 Interface Client Port                 | `2133`
| `networkInterfaces.n10Http2Client`  | Local N10 Interface Client Address                    | `10.245.216.130`
| `networkInterfaces.n10Http2ClientPort`    | Local N10 Interface Client Port                 | `2133`
| `networkInterfaces.n7Http2Client`  | Local N7 Interface Client Address                      | `10.245.216.130`
| `networkInterfaces.n7Http2ClientPort`    | Local N7 Interface Client Port                   | `2133`
| `networkInterfaces.amfIp`          | AMF IP Address                                         | `10.245.216.128`
| `networkInterfaces.amfPort`        | AMF Port                                               | `81`
| `networkInterfaces.udmIp`          | UDM IP Address                                         | `10.245.216.131`
| `networkInterfaces.udmPort`        | UDM Port                                               | `3123`
| `networkInterfaces.udmNotiServer`  | Local UDM notify server Address                        | `10.245.216.130`
| `networkInterfaces.udmNotiPort`    | Local UDM notify server port                           | `8014`
| `networkInterfaces.pcfIp`          | PCF IP Address                                         | `10.245.216.129`
| `networkInterfaces.pcfPort`        | PCF Port                                               | `7081`
| `networkInterfaces.pcfNotiServer`  | Local PCF notify server Address                        | `10.245.216.130`
| `networkInterfaces.pcfNotiPort`    | Local PCF notify server port                           | `8013`
| `networkInterfaces.upfIp`          | UPF IP Address                                         | `192.168.23.245`
| `nodeSelector`                     | SMF Node selector for pod assignment                   | `controller`
| `service`                          | SMF Kubernetes service configurations                  | `[]`
| `service.annotations`              | SMF service annotation                                 | `[]`
| `service.clusterIP`                | Cluster internal IP of SMF Service                     | `[]`
| `service.externalIPs`              | List of IP addresses that SMF service exposed          | `[]`
| `service.name_n11`                 | Name for Kubernetes service of N11                     | `n11`
| `service.name_n7`                  | Name for Kubernetes service of N7                      | `n7`
| `service.name_n10`                 | Name for Kubernetes service of N10                     | `n10`
| `service.type`                     | Configuration of SMF service types. Choosing this value makes the Service only reachable from within the cluster.      | `ClusterIP`
| `service.servicePort_n11`          | Service port for N11                                   | `3124`
| `service.servicePort_n7`           | Service port for N7                                    | `8013`
| `service.servicePort_n10`          | Service port for N10                                   | `8014`
| `resources.limits.cpu`             | Number of CPU core limited                             | `250m`
| `resources.limits.memory`          | Memory limited in mebibyte                             | `256Mi`
| `resources.requests.cpu`           | Number of CPU core requested                           | `250m`
| `resources.requests.memory`        | Memory requested in mebibyte                           | `256Mi`
| `terminationGracePeriodSeconds`    | Pod's grace period of termination                      | `30`
| `licenseSecret`                    | License secret name                                    | `license-controller`


## Contact

Please contact ASTRI for sales information.


```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Actian Corporation
```

# **Qwilt CDN Overview**

Qwilt’s Open Edge Cloud for service providers is an edge computing solution that dramatically reduces the cost of building network capacity, improves delivery quality and opens the door to new business models, customers and revenue from the OTT ecosystem.  Qwilt’s Open Edge Cloud solution delivers CDN functionality over an edge computing infrastructure, pushing the content caching and delivery as far out to the edge of the network as possible. Service providers can establish a massively distributed layer of content caching resources that enable content delivery from the closest possible location to subscribers. Each edge server is low cost and can be utilized by other virtual network function (VNF)-based services, which makes it cost effective enough to distribute throughout the service providers access network. This gives the solution an ability to scale up very rapidly without a long investment payback time.

## **Pre Requisites – Resources Required**

Qwilt Nodes Managed Content Resource Profiles

| **Virtual Platforms**              | **(M) Medium**                                              | **(L) Large**        |
| ---------------------------------- | ----------------------------------------------------------- | -------------------- |
| **Service Performance**            |                                                             |                      |
| Classification (Filtered Port 80)  | NA                                                          | NA                   |
| Delivery                           | 5  Gbps                                                     | 10  Gbps             |
| **Required Application Resources** |                                                             |                      |
| Application                        | Content Delivery                                            |                      |
| Compute* (vCores)                  | 10                                                          | 16                   |
| Memory (RAM)                       | 64 GB                                                       | 128 GB               |
| Storage (System minimum)           | 200  GB                                                     | 600  GB              |
| Storage (Content maximum)          | 20 TB                                                       | 30 TB                |
| Storage Performance                | 6  GBps   1600 IOPS                                         | 12  GBps   3200 IOPS |
| Host OS                            | CentOS 7.x                                                  |                      |
| Network                            | 10G / 40G / 100G / Virtio  Direct-Attach / SR-IOV / Virtual |                      |

## **Where to Purchase**

Qwilt CDN application image can be obtained from Qwilt's portal. For more information visit [www.qwilt.com](http://www.qwilt.com) or email sales@qwilt.com



## Pre Requisites - Installing OpenNESS

This document assumes that OpenNESS was installed through [OpenNESS playbooks](https://github.com/open-ness/specs/blob/master/doc/getting-started/network-edge/controller-edge-node-setup.md). Certain configurations had been changed to support VM deployment on OpenNESS for network edge following [openness-network-edge-vm-support.md](https://github.com/open-ness/specs/blob/master/doc/applications-onboard/openness-network-edge-vm-support.md).



## Installing Qwilt CDN application using helm

Run the following commands to deploy Qwilt CDN application through helm:

`helm install qwiltcdn ./helm/qwiltcdn`

 Sample Output would look like:

> `helm install qwiltcdn /root/openness-20.06/helm/qwiltcdn`
>
> `NAME: qwiltcdn`
>
> `LAST DEPLOYED: Tue Aug 4 11:58:55 2020`
>
> `NAMESPACE: default`
>
> `STATUS: deployed`
>
> `REVISION: 1`
>
> `TEST SUITE: None`
>
> `NOTES:`
>
> `QwiltCdn installed`	



## Uninstall Qwilt CDN application

`helm delete qwiltcdn`



## **Related material**

https://qwilt.com/

https://qwilt.com/open-edge-cloud-solutions-for-service-providers/

https://qwilt.com/content-delivery-sharing-for-content-publishers/

https://qwilt.com/edge-cloud-architecture/

https://qwilt.com/open-caching/

https://www.streamingvideoalliance.org/

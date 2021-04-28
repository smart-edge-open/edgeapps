```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 NetPico LAbs Pvt Ltd.(picoNETS)
```


# **picoCDN Platform Overview**
picoCDN is a Deep Edge focused Caching and Content Delivery Network (CDN) platform. Our Deep Edge CDN platform performs better than traditional CDNs by virtue of it unique and flexible architecture. We achieve this by bringing your content closer to your users, embedding deep into Telco and ISP networks.  With our Ultra-Low Latency CDN platform, we can deliver a buffer-free experience for Full HD, 4K, AR, VR, and other bandwidth-demanding content. Every edge location of our distribution network is geared to deliver content to users who are just a couple of hops away. We also provide a pre-caching API to push your content to the edge nodes before customers requests reach the node. This version of the platform is designed to help you deploy Edge POPs in various local ISPs, malls, hotels, airports, cellsites or other 5G Multi-Access Edge Computing (MEC) locations running Intel OpenNESS.


## **Pre Requisites – Resources Required**

| **picoCDN-VM Variants**       | **(S) Small**        | **(M) Medium**       | **(L) Large**        |
| ----------------------------- | -------------------- | -------------------- | -------------------- |
| **Service Performance**       |                      |                      |                      |
| Content Delivery              | 1  Gbps              | 5  Gbps              | 10  Gbps             |
| **Required Resources**        | -------------------- | -------------------- | -------------------- |
| Compute* (vCores)             | 4-8                  | 12+                  | 24+                  |
| Memory (RAM)                  | 16 GB                | 64 GB                | 128 GB               |
| Storage (System+Logs minimum) | 100  GB              | 200  GB              | 500  GB              |
| Storage (Content recommended) | 2-5 TB SSD           | 10-15 TB SSD         | 15-30 TB SSD         |
| Storage Performance           | 1.5 GBps  800 IOPS   | 6 GBps   1600 IOPS   | 12 GBps    3200 IOPS |
| Host OS                       <td colspan=3> picoCDN7 Custom Image </td></tr>
| Network                       <td colspan=3> 1G / 10G / 25G+ via  Virtio / Direct-Attach / SR-IOV</td></tr>


## **Where to Purchase**

The picoCDN custom image can be obtained from the picoNETS support portal. For more information visit [www.piconets.com](https://www.piconets.com) or contact us via email on info@piconets.com


## Pre Requisites - Installing OpenNESS

|**Configuration**                   |                       |
|  ----------------------------------|-----------------------|
| OpenNESS Version                   | 20.04                 |
| Flavor Used 			     | kubevirt VM           |
| Distribution	                     | IDO       	     |

This document assumes that OpenNESS was installed through [OpenNESS playbooks](https://github.com/open-ness/specs/blob/master/doc/getting-started/network-edge/controller-edge-node-setup.md). Certain configurations had been changed to support VM deployment on OpenNESS for network edge following [openness-network-edge-vm-support.md](https://github.com/open-ness/specs/blob/master/doc/applications-onboard/openness-network-edge-vm-support.md).

## Downloading VM Images

Download and deploy the latest release of the picoCDN7 custom VM image found at https://demo.picocdn.net/installer/picoCDN7-latest.qcow2

## Installing picoCDN-VM using helm

The default picoCDN-VM node variant that is installed by the following commands is the (S)Small variant. If you wish to a different variant to be installed, please copy the appropriate "values.yaml-{small,medium,large}" file over to "values.yaml" prior to running the deployment commands.

Prior to running the helm deployment, please ensure that the IP values in templates/cdn-service.yaml are appropriate to your site.

Run the following commands to deploy through helm:

```shell
$ helm install picocdn ./picocdn-node-vm
```

 Sample Output would look like:

```shell
>  NAME: picocdn
>  LAST DEPLOYED: Tue Apr 27 22:51:36 2021
>  NAMESPACE: default
>  STATUS: deployed
>  REVISION: 1
>  TEST SUITE: None
>  NOTES:
>  # SPDX-License-Identifier: Apache-2.0
>  # Copyright (c) 2021 picoNETS
>  picoCDN Node installed
```
Once you are succesfully deployed, you can proceed with the Testing and Activation process.

## Testing and Activation Steps

Please contact the picoNETS support team to complete provisioning and service activation as per your chosen service plan.

## Uninstall picoCDN-VM application
To uninstall application run below command:

```shell    
$ helm uninstall picocdn
```

## **Related material**
* picoCDN Information : https://www.piconets.com/cdn
* picoCDN NodeAPI Documentation : http://demo.picocdn.net/installer/picoCDN_NodeAPI_V2_Specification_Generic.pdf

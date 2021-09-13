```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Herta Security
```


# **Herta Connect Application Overview**
Herta is specialized in the analysis of crowded environments, making it possible to detect and identify multiple subjects at the same time through IP cameras. Our software is completely scalable and compatible with any IP camera, becoming a user friendly and accessible tool for any business organization.


## **Pre Requisites – Resources Required**

| **Resource Information**           |                      |
|------------------------------------|----------------------|
| Application Type                   | Video-Analytics		| 
| Compute  (vCores)                  | 8                    |
| Memory (RAM)                       | 8 GB                 |
| Storage 				             | 32  GB               |
| Host OS                            | Linux 5.4            | 
  


## **Where to Purchase**
Visit us at https://herta.ai or email sales@hertasecurity.com


## Pre Requisites - Installing OpenNESS
|**Configuration**                   |                       |
|  ----------------------------------|-----------------------|
| OpenNESS Version                   | 21.02                 |
| Flavor Used 					     | Minimal				 |
| Distribution						 | OpenSource    	     |


Follow below link to to get set up with OpenNESS.

https://github.com/open-ness/specs/blob/master/doc/getting-started/openness-cluster-setup.md

## Loading Docker Images
docker image load -i herta-connect.tar.gz

## Installing Herta Connect Application using helm

Run the following commands to deploy  through helm:

```
$ cd applications/herta-connect
$ helm install hc-openness helm/hc-openness
```


## Uninstall Herta Connect application
To uninstall the application run below command:
    
`helm uninstall hc-openness`

## **Related material**
* See our website at https://herta.ai


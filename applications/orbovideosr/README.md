```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 ORBO
```


# **Orbo VideoSR Application Overview**
Orbo Video Super Resolution converts a low resolution video into high resolution video.


## **Pre Requisites – Resources Required**

| **Resource Information**           |                      |
|------------------------------------|----------------------|
| Application Type                   | Video-Enhancement		| 
| Compute  (vCores)                  | 8                    |  
| Memory (RAM)                       | 16 GB                |  
| Storage 				             | 200  GB              |  
| Host OS                            | CentOS 7.6.1810      | 
  


## **Where to Purchase**
Contact support@orbo.ai


## Pre Requisites - Installing OpenNESS
|**Configuration**                   |                       |
|  ----------------------------------|-----------------------|
| OpenNESS Version                   | 20.12.02		         |
| Flavor Used 					     | Minimal				 |
| Distribution						 | OpenSource    	     |


Follow below link to setup controller and edge-node for installing OpenNESS.

https://github.com/open-ness/specs/blob/openness-20.12.02/doc/getting-started/network-edge/controller-edge-node-setup.md

* Go to openness-experience-kits/ directory and comment out the grub role (role: machine_setup/grub) in the **network_edge.yml** file.
* Run the deployment script as ./deploy_ne.sh 

## Loading Docker Images
docker image load -i openness-sr5000.tar.gz

## Installing VideoSR Application using helm

Run the following commands to deploy  through helm:

`helm install orbovideosr ./`

 Sample Output would look like:

> `NAME: orbovideosr`
>
> `LAST DEPLOYED:`
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
> `# SPDX-License-Identifier: Apache-2.0`
> 
> `# Copyright (c) 2021 ORBO`
> 
> `orbovideosr was installed.`
> 
> `Your release is named orbovideosr.`
> 
> `To learn more about the release, try:`
> 
> `$ helm status orbovideosr`
> 
> `$ helm get orbovideosr`


## Uninstall VideoSR application
To uninstall application run below command:
    
`helm uninstall orbovideosr`

## Testing Steps
For further instructions about steps for testing, contact Support (support@orbo.ai)

## **Related material**
* https://orbo.ai/


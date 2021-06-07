```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 DeepSight AI Labs
```


# **Supersecure Application Overview**
SuperSecure is a universally compatible retrofit solution, that works with any CCTV system, any camera, any resolution and turn it into an AI powered Smart Surveillance Solution to detect potential threats with high accuracy and trigger instant alerts to save lives and protect assets.


## **Pre Requisites – Resources Required**

| **Resource Information**           |                      |
|------------------------------------|----------------------|
| Application Type                   | Video-Analytics		| 
| Compute  (vCores)                  | 8                    |  
| Memory (RAM)                       | 16 GB                |  
| Storage 				             | 200  GB              |  
| Host OS                            | CentOS 7.6.1810      | 
  


## **Where to Purchase**
Contact nishant@deepsightlabs.com


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
docker image load -i dsal_openvino_v2.tar.gz

## Installing SuperSecure Application using helm

Run the following commands to deploy  through helm:

`helm install supersecure ./`

 Sample Output would look like:

> `NAME: supersecure`
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
> `# Copyright (c) 2021 DeepSight AI Labs`
> 
> `deepsight-supersecure was installed.`
> 
> `Your release is named supersecure.`
> 
> `To learn more about the release, try:`
> 
> `$ helm status supersecure`
> 
> `$ helm get supersecure`


## Uninstall SuperSecure application
To uninstall application run below command:
    
`helm uninstall supersecure`

## Testing Steps
For further instructions about steps for testing, contact Nishant (nishant@deepsightlabs.com)

## **Related material**
* https://deepsightlabs.com/


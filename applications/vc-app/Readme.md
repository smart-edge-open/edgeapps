
# **Vision Captor Application Overview**
Using artificial intelligence and machine learning, VisionCaptor delivers targeted display content at the point of purchase.

## **Pre Requisites – Resources Required**

| **Resource Information**           |                      |
|------------------------------------|----------------------|
| Application Type                   | Vision Captor		| 
| Compute  (vCores)                  | 8                    |  
| Memory (RAM)                       | 8 GB                 |  
| Storage 				             | 128 GB               |  
| Host OS                            | Ubuntu 20 or higher  |  
| Physical Display                   |                      |
| Connected cameras(USB/IP/Network)  | With RTSP URL        |    
  


## **Where to Purchase**
Contact info@vsblty.net


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

## Pre Requisites - Installing Vision Captor
|**Configuration**                   |                                    |
|  ----------------------------------|------------------------------------|
| Ubuntu                             | 20 or later		                  |
| Folder to create on system 		 | /home/vedge/models	              |
| Folder to create on system 		 | /home/vedge/gallery	              |
| Folder to create on system 		 | /home/vedge/videos	              |
| Folder to create on system 		 | /root/.Xauthority	              |
| Folder to create on system 		 | /home/vclite/Usage	              |
| Folder to create on system 		 | /home/vclite/KioskServicesMedia	  |



## Loading Docker Images
docker image load -i vc-app.tar.gz

## Installing Vision Captor Application using helm

Run the following commands to deploy  through helm:

`helm install vc-app ./vc-app`

 Sample Output would look like:

> `NAME: vc-app`
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



## Uninstall Vision captor application
To uninstall application run below command:
    
`helm uninstall vc-app`

## Testing Steps
For further instructions about steps for testing, contact VSBLTY Team (info@vsblty.net)

## **Related material**
* https://vsblty.net/
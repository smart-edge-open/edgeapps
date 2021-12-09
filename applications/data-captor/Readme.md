
# **Data Captor Application Overview**
DataCaptor leverages camera and sensor technology through AI tools (machine learning and computer vision), enabling real-time analytics and anonymous audience data based on who and what the camera sees

## **Pre Requisites – Resources Required**

| **Resource Information**           |                      |
|------------------------------------|----------------------|
| Application Type                   | Data Captor		    | 
| Compute  (vCores)                  | 8                    |  
| Memory (RAM)                       | 8 GB                 |  
| Storage 				             | 128 GB               |  
| Host OS                            | Ubuntu 20 or higher  |  
| Physical Display                   |                      |
| Connected cameras(USB/IP/Network)  | With RTSP URL        |    
  


## **Where to Purchase**
Contact info@vsblty.net


## Pre Requisites - Installing Data Captor
|**Configuration**                   |                                    |
|  ----------------------------------|------------------------------------|
| Ubuntu                             | 20 or later		                  |
| Folder to create on system 		 | /home/vedge/models	              |
| Folder to create on system 		 | /home/vedge/gallery	              |
| Folder to create on system 		 | /home/vedge/videos	              |



## Loading Docker Images
docker image load -i data-captor.tar.gz

## Installing Data Captor Application using helm

Run the following commands to deploy  through helm:

`helm install data-captor ./data-captor`

 Sample Output would look like:

> `NAME: data-captor`
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



## Uninstall Data captor application
To uninstall application run below command:
    
`helm uninstall data-captor`

## Testing Steps
For further instructions about steps for testing, contact VSBLTY Team (info@vsblty.net)

## **Related material**
* https://vsblty.net/
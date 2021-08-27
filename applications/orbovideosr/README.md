```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Modaviti eMarketing Private Limited
```

# ORBO AI (A Product of Modaviti eMarketing Private Limited)
ORBO AI provides a cutting edge visual AI platform to solve problems associated with low quality & low resolution visuals to boost conversions and higher customer satisfaction. These Visual AI solutions enable visual enhancement, AI automation and visual insights.

ORBO’s team of AI experts have developed cutting edge computer vision and deep learning technology based on years of research that is tested on large data sets. The visual AI solutions help to improve the quality of visuals by enhancing the details.

Higher quality visuals provide a better customer experience and lead to higher satisfaction levels and more conversions.

# **ORBO VideoSR Application Overview**
Low quality video hampers the viewer experience. In today’s time when people are connecting through video conferencing and consuming video content, the quality of video is critical. ORBO AI’s Super Resolution Video Solution enables the streaming of high-quality video on low internet bandwidth. The AI converts low quality video to high quality in real time on the edge. No infrastructure investment is required. ORBO AI’s Super Resolution Video can be leveraged by OTT platforms, Live TV Apps, Social Video Apps and even Educational Platforms that deliver content via video.



## **Pre Requisites – Resources Required**

| **Resource Information**           |                      |
|------------------------------------|----------------------|
| Application Type                   | Video-Enhancement	| 
| Compute  (vCores)                  | 8                    |  
| Memory (RAM)                       | 16 GB                |  
| Storage 				             | 200  GB              |  
| Host OS                            | CentOS 7.9.2009      | 
  


## **Where to Purchase**
Contact support@orbo.ai


## Pre Requisites - Installing OpenNESS

|**Configuration**                   |                          |
|  ----------------------------------|--------------------------|
| OpenNESS Version                   | 21.03.05		            |
| Flavor Used 					     | CERA Minimal Flavor	    |
| Distribution						 | OpenSource    	        |


Follow below link to setup controller and edge-node for installing OpenNESS.

https://github.com/open-ness/specs/blob/master/doc/getting-started/openness-cluster-setup.md


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


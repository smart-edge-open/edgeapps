```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Modaviti eMarketing Private Limited
```

# Overview of ORBO AI (A Product of Modaviti eMarketing Private Limited)
ORBO AI is a leading Computer vision research company that brings AI automation and visual enhancement stack to the edge-based applications cuts through multiple business segments such as Media, Healthcare, Edtech, Security and surveillance, Banking etc. 

ORBO AI provides a cutting-edge visual AI platform to solve problems associated with low quality & low-resolution visuals to boost conversions and higher customer satisfaction. These Visual AI solutions enable visual enhancement, AI automation and visual insights.

ORBO’s team of AI experts have developed cutting edge computer vision and deep learning technology based on years of research that
is tested on large data sets. The visual AI solutions help to improve the quality of visuals by enhancing the details.

# **ORBO Video SR Application Description**
ORBO AI has built a series of advance computer vision & deep learning-based IP that brings AI automation to organization.

Even though internet speeds are increasing, the last mile connectivity to mobile devices gets hampered due to issues like poor network connectivity, high congestion at peak time periods, lack of strong connection within buildings, etc. High Quality Video is required when people are consuming video content like movies, web series, educational videos or even social videos. Low quality video hampers the viewer experience. It is extremely difficult to control the quality of the internet. Hence it is important for the company providing the content to optimize delivery to its users.

In today’s time when people are connecting through video conferencing and consuming video content, the quality of video can significantly impact business. ORBO AI’s Super Resolution Video Solution enables the streaming of high-quality video on low internet bandwidth. 

The best part of ORBO’s AI is that it converts low quality video to high quality in real time on the edge. No infrastructure investment is
required. ORBO AI’s Super Resolution Video can be leveraged by OTT platforms, Live TV Apps, Social Video Apps and even Educational
Platforms that deliver content via video.

With ORBO’s Video Enhancement AI technology installed, the quality of the video can easily be enhanced in real time on lower
bandwidth leading to a better viewing experience and higher conversions.



## **Pre Requisites – Resources Required**

| **Resource Information**           |                                              |
|------------------------------------|----------------------------------------------|
| Application Type                   | Video-Enhancement	                        |
| CPU                                | Intel core processor 6th Generation or newer.|   
| Compute  (vCores)                  | 6                                            |  
| Memory (RAM)                       | 8 GB                                         |  
| Storage 				             | 200  GB                                      |  
| Host OS                            | CentOS 7.9.2009                              | 
  


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
docker image load -i orbovideosr.tar.gz

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


```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Modaviti eMarketing Private Limited
```

# Overview of ORBO AI (A Product of Modaviti eMarketing Private Limited)
ORBO AI is a leading Computer vision research company that brings AI automation and visual enhancement stack to the edge-based applications cuts through multiple business segments such as Media, Healthcare, Edtech, Security and surveillance, Banking etc. 

ORBO AI provides a cutting-edge visual AI platform to solve problems associated with low quality & low-resolution visuals to boost conversions and higher customer satisfaction. These Visual AI solutions enable visual enhancement, AI automation and visual insights.

ORBO’s team of AI experts have developed cutting edge computer vision and deep learning technology based on years of research that
is tested on large data sets. The visual AI solutions help to improve the quality of visuals by enhancing the details.

# **ORBO AI Image Enhancement Application Description**
Images can suffer from degradations caused by movement or camera shake, poor lighting, long exposure, noise and color loss due to compression. Then there are old stored images in physical form that get degraded over time. Organisations spend a lot of time and money on fixing image issues. Businesses that use poor quality images see poor conversions.

ORBO AI has built a novel AI for Image Enhancement that can automatically fix image issues and enhance photos instantly.

It can fix various issues like lowlight, over exposure, color loss, noise, compression and can be leveraged by businesses across verticals like Real Estate, E-commerce, Travel, Automotive, Food, Fashion, Beauty and many more! 

Key feature under ORBO’s AI Image Enhancement

AI SUPER HDR - Bring out the colour tones and make the product look attractive

AUTO UPSCALE upto 8X - Remove compression and increase resolution of the image

AUTO DEHAZE - Control Exposure and do color recovery

AI LOW LIGHT FIX - Resolve under exposure to make the image attractive

AI DENOISE - Resolve under exposure to make the image attractive

AUTOMATIC CENTER & ALIGNMENT - Resolve alignment issues in images for e-commerce



## **Pre Requisites – Resources Required**

| **Resource Information**           |                                              |
|------------------------------------|----------------------------------------------|
| Application Type                   | AI-Image-Enhancement	                        |
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

https://github.com/smart-edge-open/specs/blob/master/doc/getting-started/smartedge-open-cluster-setup.md


## Loading Docker Images
docker image load -i orbo_image_enhancement.tar.gz

## Installing ORBO AI Image Enhancement Application using helm

Run the following commands to deploy  through helm:

`helm install orbo-image-enhancement ./`

 Sample Output would look like:

> `NAME: orbo-image-enhancement`
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
> `# Copyright (c) 2021 Modaviti eMarketing Private Limited`
> 
> `orbo-image-enhancement was installed.`
> 
> `Your release is named orbo-image-enhancement.`
> 
> `To learn more about the release, try:`
> 
> `$ helm status orbo-image-enhancement`
> 
> `$ helm get orbo-image-enhancement`


## Uninstall ORBO AI Image Enhancement Application
To uninstall application run below command:
    
`helm uninstall orbo-image-enhancement`

## Testing Steps
For further instructions about steps for testing, contact Support (support@orbo.ai)

## **Related material**
* https://orbo.ai/


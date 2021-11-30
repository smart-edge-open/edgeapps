```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Modaviti eMarketing Private Limited
```

# Overview of ORBO AI (A Product of Modaviti eMarketing Private Limited)
ORBO AI is a leading Computer vision research company that brings AI automation and visual enhancement stack to the edge-based applications cuts through multiple business segments such as Media, Healthcare, Edtech, Security and surveillance, Banking etc. 

ORBO AI provides a cutting-edge visual AI platform to solve problems associated with low quality & low-resolution visuals to boost conversions and higher customer satisfaction. These Visual AI solutions enable visual enhancement, AI automation and visual insights.

ORBO’s team of AI experts have developed cutting edge computer vision and deep learning technology based on years of research that
is tested on large data sets. The visual AI solutions help to improve the quality of visuals by enhancing the details.

# **ORBO Background Removal Application Description**
Background removal is one of the most critical issues in image editing. Companies across sectors incur a time and money to remove background to bring focus on the subject. For example, as per governing laws, banks need to have portrait image of customer with a white background. Similarly, in e-commerce, sellers need to list their product image with white or grey or a standard color background so that the e-commerce website looks consistent and attractive. If sellers starts putting product images with different backgrounds, the e-commerce platform might look cluttered.

Till now, background removal was done on traditional photo editing software that was manual intensive and time consuming.

ORBO AI’s Background Removal AI can easily remove the background from the subject instantly saving companies hours of manual work and cost.



## **Pre Requisites – Resources Required**

| **Resource Information**           |                                              |
|------------------------------------|----------------------------------------------|
| Application Type                   | Background Removal	                        |
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
docker image load -i orbo_background_removal.tar.gz

## Installing ORBO Background Removal Application using helm

Run the following commands to deploy  through helm:

`helm install orbo-background-removal ./`

 Sample Output would look like:

> `NAME: orbo-background-removal`
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
> `orbo-background-removal was installed.`
> 
> `Your release is named orbo-background-removal.`
> 
> `To learn more about the release, try:`
> 
> `$ helm status orbo-background-removal`
> 
> `$ helm get orbo-background-removal`


## Uninstall ORBO Background Removal Application
To uninstall application run below command:
    
`helm uninstall orbo-background-removal`

## Testing Steps
For further instructions about steps for testing, contact Support (support@orbo.ai)

## **Related material**
* https://orbo.ai/


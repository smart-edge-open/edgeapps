```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

# EII Applications with OpenNESS
The purpose of this source code is to deploy EII applications on OpenNESS platform.

Edge Insights for Industrial (EII) is the framework for enabling smart manufacturing with visual and point defect inspections.

More details about EII:
[https://www.intel.com/content/www/us/en/internet-of-things/industrial-iot/edge-insights-industrial.html](https://www.intel.com/content/www/us/en/internet-of-things/industrial-iot/edge-insights-industrial.html)

Currently, `eis-experience-kit` supports EII version 2.4

- [Pre-requisites](#pre-requisites)
- [Installation Process](#installation-process)
    - [Getting The Sources](#getting-the-sources)
    - [Build Stage](#build-stage)
    - [Deploy Stage](#deploy-stage)
    - [Cleanup](#cleanup)
- [Configuration](#configuration)
    - [Getting Sources Settings](#getting-sources-settings)
    - [Build Settings](#build-proxy-settings)
    - [Deploy Settings](#deploy-settings)
    - [Inventory](#inventory)
    - [Playbook Main File](#playbook-main-file)
    - [EII Demo Setting](#eii-demo-setting)
        - [RTSP Stream Setting](#rtsp-stream-setting)
    - [View Visualizer Setting](#view-visualizer-host-server)
- [Installation](#installation)
- [Web Visualizer Display](#web-visualizer-display)
- [Removal](#removal)
- [References](#references)


## Pre-requisites
EII applications require Network Edge OpenNESS platform to be deployed and working on OpenNESS `Single Node Deployment`.
```sh
#deploy.py
```

## Installation Process
The major part of this repository is Ansible scripts set. They are used for EII application build and deployment. Most of the roles are split into two stages - build and deploy. The first part is performed on the same host as Ansible scripts and the second one is run on OpenNESS Control Plane Node.

User can manage which components will be executed during the deployment.

### Getting The Sources

The EII release package can be downloaded from here: [https://software.intel.com/iot/edgesoftwarehub/download/home/industrialinsights](https://software.intel.com/iot/edgesoftwarehub/download/home/industrialinsights)

During download select following option.
```sh
Download Version :2.4
Target System OS :Ubuntu 18.04.LTS
Select Use Case :Video Analytic
```
During  download we will get product key, keep this product key which will use while preparing edgesoftware download.

After release package download follow this link for getting EII release package on `Ubuntu 18.04.LTS` Host: [https://software.intel.com/content/www/us/en/develop/documentation/edge-insights-industrial-doc/get-started-guide.html](https://software.intel.com/content/www/us/en/develop/documentation/edge-insights-industrial-doc/get-started-guide.html)


```sh
#unzip edge_insights_industrial.zip
#cd edge_insights_industrial
#./edgesoftware download
```
**Note**:
- Run above download command on  `Ubuntu 18.04.LTS` HOST or VM.
- After download success copy EII release package `Edge_Insights_for_Industrial_2.4` on ansible Host machine.

### Build Stage
Overview on `eis-experience-kit` architecture:

![eis-experience-kit architecture](docs/images/eis_deployment_diagram.png)

All the `build` tasks are performed on `External Ansible machine` localhost. It is the same machine that Ansible Playbook is run on. These tasks contain installation of all required prerequisites for building the applications images and all steps related to building docker images. All images, after successful build, are tagged and pushed to the Docker Registry that is a part of OpenNESS platform. They will be used by Kubernetes later, in `deploy` stage. 

### Deploy Stage
`Deploy` tasks are executed on OpenNESS Control Plane Node. These tasks include EII provision and generation of certificates and deployment of `etcd`,`video-analytics`,`video-ingestion`,`visualizer`,`webvisualizer`,`camera-stream` pod. All these things are done just before the particular application has been deployed. For the deployment `kubectl` command and Kubernetes manifest files have been used. 

### Cleanup
All the roles in Ansible Playbook have clean up scripts that can be run to reverse the build and deploy tasks. It should be used only for debug purposes. It is not guarantee that clean up scripts will remove everything that has been added by build & deployment stages. In the most cases it is enough for running the deployment of particular application or the whole EII again. `cleanup_eis_deployment.sh` is a shell scripts that is running a sequence of cleaning tasks that should cover all the `deploy_eis.sh` changes on the setup.

**Note**:
- `deploy_eis.sh` and `cleanup_eis_deployment.sh` script must run on External Ansible build machine 
 
## Configuration
User can configure the installation of EII by modifying the files that contain variables used widely in Ansible Playbook. All the variables that can be adjusted by the user are placed in `host_vars` directory.


### Getting Sources Settings
`eis-experience-kit`  use pre-downloaded EII release package. User needs to add path on `release_package_path` variable on `host_vars/localhost.yml`


```sh
eis_source: "release"
release_package_path: "/root/Edge_Insights_for_Industrial_2.4/IEdgeInsights/"
```


### Build Proxy Settings
`host_vars/localhost.yml` file contains all the settings specific for build process that is performed on localhost. User can set proxy settings and how the EII sources will be handled.

- If proxy setting require update variable on `host_vars/localhost.yml` as per system proxy requirement.
```sh
proxy_os_enable: true
proxy_os_remove_old: true
proxy_os_http: "http://proxy.example.org:3129"
proxy_os_https: "http://proxy.example.org:3128"
proxy_os_ftp: "http://proxy.example.org:3128"
proxy_os_noproxy: "localhost,127.0.0.1,192.168.0.0/16"
proxy_yum_url: "http://proxy.example.org:3128"
```



### Deploy Settings
The second one is regarding the `deploy` process. All the settings are in `openness_controller.yml` file. It is for the action that will occur on OpenNESS Control Plane Node. It contains mostly the values for certificates generation process and paths for Kubernetes deployment related files.

### Inventory
User needs to set the OpenNESS Control Plane Node IP address. It can be done in `inventory.ini` file.

### Playbook Main File
The main file for playbook is `eis.yml`. User can define here which roles should be run during the build & deployment. They can be switch by using comments for unnecessary roles.

### EII Demo Setting
eis-experience-kit currently  we can configure for  Demo type as

- PCB Demo
- Safety Demo

Following flags controll for configuring demo type on `group_vars/all.yml`
```sh
demo_type: "safety"  -> for Safety Demo
demo_type: "pcb"     -> for PCB Demo
```
#### RTSP Stream Setting
Currently RTSP camera steam data can be received follwing source  
   - rtsp stream from  camera-stream pod
   - rtsp stream from Linux host
   - rtsp stream from Window host

on eis-experience-kit  demo  default rtsp strem  will recive from camera-stream pod.
Follwing flags are contrl for receving receiving rtsp strem on `group_vars/all.yml`

#### Enable rtsp stream from  camera-stream pod(Default)
```sh
    camera_stream_pod: true  
    rtsp_camera_stream_ip: "ia-camera-stream-service" 
    rtsp_camera_stream_port: 8554               
```
#### Enable rtsp stream from  external Linux/Window host
 ```sh
    camera_stream_pod: false  
    rtsp_camera_stream_ip: "192.169.1.1"   < update Linux/window external rtsp server IP>
    rtsp_camera_stream_port: 8554               
```

####  Send rtsp stream from external Linux (CentOS)
```sh
yum install -y epel-release  https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
yum install -y vlc
sed -i 's/geteuid/getppid/' /usr/bin/vlc
./send_rtsp_stream_linux.sh <file_name> <port_name>
```
####  Send rtsp stream from external Linux (ubuntu)

```sh
apt-get install vlc
sed -i 's/geteuid/getppid/' /usr/bin/vlc
./send_rtsp_stream_linux.sh <file_name> <port_name>
```
####  Send rtsp stream from external Windows Host

```sh
#install  vlc player <https://www.videolan.org/vlc/download-windows.html>
#update follwing varaible on  send_rtsp_stream_linux.sh
set vlc_path="c:\Program Files (x86)\VideoLAN\VLC"
set file_name="c:\Data\Safety_Full_Hat_and_Vest.avi"  < update Demo file name>
set port="8554"
#next run   send_rtsp_stream_win.bat file 
```

**Note**: Following script and demo video file should copied from ansible host machine

    `/eis-experience-kit/scripts/send_rtsp_stream_linux.sh`
    `/eis-experience-kit/scripts/send_rtsp_stream_win.bat`
    `/opt/eis_repo/IEdgeInsights/VideoIngestion/test_videos/pcb_d2000.avi`
    `/opt/eis_repo/IEdgeInsights/CustomUdfs/NativeSafetyGearIngestion/Safety_Full_Hat_and_Vest.avi`


### View Visualizer HOST Server
Currently default setting is enabled for **web_visualizer**.
This setting is `optional` only if we want to view visualizer on any HOST server, Update IP address of host server where we want to see the GUI output, Visualizer container will expose the GUI output on display host.
```sh 
display_visualizer_host: true
display_host_ip: "192.168.0.1"     < Update Display Host IP>
display_no: "1"                    <Update Display no>
```

**Note**:
- Display host shoud have GUI/VNC access and check the Display by echo $DISPLAY 
update the display on above `display_no`.
- configure `xhost +` on Display host for receiving  video GUI  

## Installation
After all the configuration is done, script `deploy_eis.sh` needs to be executed to start the deployment process. No more actions are required, all the installation steps are fully automated. 

- Run EII `deploy_eis.sh` script on External Ansible host

```sh
# cd edgeapps/applications/eis-experience-kit
# ./deploy_eis.sh

```
**Note**:
- if we do freshly install EII for fist time EII deplyment will take `2 to 3 Hours` for build and deplyment.

After `deploy_eis.sh` deployment success all pod should be in running state on eis namespace on OpenNESS Control Plane Node

- Pod list for PCB demo
```sh
# kubectl -n eis get pod
NAME                                          READY   STATUS    RESTARTS   AGE
deployment-video-analytics-77c55fc4b5-dc2hf   1/1     Running   0          19h
deployment-video-ingestion-6566957ddc-96mgq   1/1     Running   0          19h
deployment-webvisualizer-6877cfbdbd-h9dmv     1/1     Running   0          19h
ia-camera-stream-f487cf9d-7jzxt               1/1     Running   0          19h
ia-etcd                                       1/1     Running   0          19h
#
```

- Pod list for Safety demo
```sh
# kubectl -n eis get pod
NAME                                                       READY   STATUS    RESTARTS   AGE
deployment-python-safety-gear-analytics-86664d55c8-jnm68   1/1     Running   0          2d21h
deployment-python-safety-gear-ingestion-58d7d67bb6-r7pv5   1/1     Running   0          2d21h
deployment-video-analytics-77c55fc4b5-g5h22                1/1     Running   0          2d21h
deployment-video-ingestion-6566957ddc-2snv8                1/1     Running   0          2d21h
deployment-webvisualizer-6664bccc4d-wt2tx                  1/1     Running   0          2d21h
ia-camera-stream-6766f879f-rm8g7                           1/1     Running   0          2d21h
ia-etcd                                                    1/1     Running   0          2d21h
#

```
## Web Visualizer display

After EII deployed successfully output can be viewed using

`https://<controller_IP>:30007`

username:`admin`

password:`admin@123`

**Note**:
Open Web Visualizer on google chrome browser, if connection is not private show, select Advanced option and proceed to.


## Removal
To clean up the platform from EII applications `cleanup_eis_deployment.sh` script can be used. It runs Ansible playbook `eis_cleanup.yml` and processes all the roles defined there. Inventory file is used for getting Control Plane Node IP.

## References
- [Edge Insights for Industrial Application on OpenNESS — Solution Overview](docs/whitepaper.md)
- [Intel’s Edge Insights for Industrial](https://www.intel.com/content/www/us/en/internet-of-things/industrial-iot/edge-insights-industrial.html)

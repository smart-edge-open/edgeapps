# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Altran Technology

Overview of Altran V2X Apps:
=============================

Altran V2X solution enables safety & non-safety applications for V2V,V2I,V2P and V2N scenarios for Road Side Units (RSU), On Board Units (OBU) and Smart Pedestrian Devices . The solution comes with application and underlying stack conformant to regional standards - WAVE / ETSI and China.

V2X Application Description:    
==============================
Following Vehicle To Infrastructure (V2I) applications are supported:

Roadside Alert (RSA): RSU periodically broadcast advisory messages about the road hazards (Slippery Road, Animal On the Road etc.)

Electric Vehicle Charging Station (EVCSN): RSU periodically broadcast presence and occupancy status of nearby Electric changing station Information

Vulnerable Road User (VRU): RSU detect vulnerable road user and broadcast the same information to near-by vehicles

Time To Green (TTG) / Green Light Signal (GLOSA): RSU broadcast the traffic signals state and time information to near-by vehicles in an intersection

Separate container images are provided for OBU / RSU apps which can be onboarded (as pods) and communicate over UDP/IP interface. A Human Machine Interface (HMI) app is provided for visualization and demo purpose. In real deployment scenario the UDP/IP interface could be replaced by C-V2X PC5 or C-V2X Uu air interface

Retrieve Container Images and Helm Charts

Containers: Contact Altran Sales

Helm Charts: https://gurftp03.aricent.com/webclient/Login.xhtml

Pre-Requisite:
=================

Cluster with minimum 1 Master and 1 Slave. (Recommended 2-Slaves and 1-Master)
Altran provided container images for V2X RSU/OBU Apps
Note: Air interface integration requires third party radio integration for C-V2X PC5 interface and MNO application server for C-V2X Uu interface



Deploy service:
=================
From the Controller Node, go to helm chart folder of the repository:

$ helm install altran <helm-chart location> --set service.type=NodePort

Show helm is installed

$helm get all altran

After helm Install we need to change the config file of each pods as Host Vehicle ,Remote Vehicle and RSU.

Execute each binary


Test Output:
================
Follow the docs on website.

Uninstall chart:
====================
helm uninstall v2xstack




Many more V2X apps can be supported based on request

................................................................

Where to Purchase :
=====================
The Altran V2X application is available in the Altran provided shareable repository upon request. Please contact Altran sales for details.
Contact Altran Sales Support:
Email : marketing@altran.com

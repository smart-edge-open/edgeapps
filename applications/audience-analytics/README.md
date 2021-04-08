```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Kibernetika, Inc. All rights reserved.
```

# Audience analytics

- [Audience analytics](#audience-analytics)
  - [Application Description](#application-description)
  - [Repository content](#repository-content)
  - [Docker Images](#docker-images)
  - [Pre Requisites](#pre-requisites)
  - [Installation](#installation)
    - [Install the Audience analytics](#install-the-audience-analytics)
    - [Producer Application](#producer-application)
    - [Check application logs to see if it is running](#check-application-logs-to-see-if-it-is-running)

## Application Description

The Application is a Audience analytics registered in OpenNESS as a consumer application. It uses
a web UI for visualizing heatmap pictures, aggregated heatmap pictures, heatmap video and person statistics from the timeline.
It receives the data and pictures from the producer application "Realtime Heatmap".

## Repository content

The repository contains:

-	Helm package for the installation

## Docker Images

Docker images are located at dockerhub:

- kuberlab/audience:latest
- kuberlab/audience-ui:latest

Pre Requisites
---
The application has been tested on the following software, which is also required:

* [OpenNESS](https://github.com/open-ness/specs) Network Edge v20.12.02
* Kubernetes v1.18.4
* Helm v3.1.2
* Installed [nginx-ingress](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm) controller in cluster with nodePort
* Available at least one storage class for storage

## Installation

### Install the Audience analytics

The installation proccess leverage on helm chart. Go to the `helm` folder of the repository, and edit values.yaml:

Notice environment variables:

Notice chart variables:

- api.dns: Domain name for nginx controller
- api.db.password: specify password for the database
- api.authKey: specify random auth key for root API user
- Uncomment persistence.*.storageClass variables and specify an appropriate storageClass used in your cluster

Run the installation:

```bash
helm install realtime-heatmap ./
```

If the installation succeeds, you can check the logs. If everything is ok and DNS is pointed to edge node IP,
then check `<some-node-ip>:<nginx-node-port>` for accessing audience UI using login/password: `admin/<your-auth-key>`

### Producer Application

The Producer application here is the "Realtime Heatmap" application which produces frames, heatmap labeling and
resulting video chunks and sends them to audience service.

### Check application logs to see if it is running

In order to check application logs, you can see directly the pod logs at:

```bash
pod_name=$(kubectl get po -l component=audience-api --no-headers | awk '{print $1}')
kubectl logs -f $pod_name
```

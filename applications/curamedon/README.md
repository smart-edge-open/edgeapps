```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Inno Barn. All rights reserved.
```
# Curamedon

## Introduction
Curamedon is a ready-made web-based service that allows health practitioners’ offices to consult with patients via videoconferencing.
This repository contains Helm Charts and instructions to help with Curamedon services deployment to Intel Smart Edge Open.
For more information on Curamedon, please visit our website: [Curamedon](https://curamedon.com)

## Prerequisites
The application has been tested on the following software, which is also required:

* Intel Smart Edge Open (release 21.09)
* Kubernetes v1.20
* Helm v3.1.2

## Installation

### Ingress Controller setup
First thing to do is to set up ingress controller. Installation guide https://kubernetes.github.io/ingress-nginx/deploy.

### Setup Cert Manager
Next step is to set up cert manager. Use instructions from https://cert-manager.io/docs/installation/helm.

Once cert manger is set up cluster issuers must be configured. Follow instruction from https://cert-manager.io/docs/configuration/acme/.
It is expected that `letencrypt-prod` issuer is configured and ready to use.

### Prepare StorageClass
It is not recommended to use `hostPath` or `local` PV for production environment. The best way is to set up `NFS` or use some
plugins to integrate with cloud storages (AWS, Azure etc.). At least one corresponding StorageClass that supports dynamic volume provisioning should be available by default.
See details on https://kubernetes.io/docs/concepts/storage/storage-classes/

### Create a namespace
Run
> kubectl create namespace telemedicine

### Install MySQL
Use https://github.com/bitnami/charts/tree/master/bitnami/mysql to set up MySQL.
Important thing to do is to configure timezone: we need to populate one system table with human-readable timezone names and setup default
timezone to UTC (`initdbScripts` section). Provided database name, user and password will be needed during
application deployments (Api, Backoffice, Oauth).

<pre>
initdbScripts:
  load_timezones.sh: |
    #!/bin/bash
    mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root - p '<root password here>' mysql
  set_default_timezone.sql: |
    SET GLOBAL time_zone = 'UTC'
</pre>

### Install Elasticsearch
Use https://github.com/bitnami/charts/tree/master/bitnami/elasticsearch to setup Elasticsearch. It is used for professionals search
in Curamedon Web Applications and indexing available timeslots.

### Install Redis
Use https://github.com/bitnami/charts/tree/master/bitnami/redis to set up Redis. We use Redis as a queue for some background tasks.

### Install Mercure Hub

Use official helm charts to setup Mercure Hub https://github.com/dunglas/mercure/tree/main/charts/mercure.
Mercure is used for real-time notifications for Curamedon Web Applications. You need to override keys to sign JWT tokens.
HS256 is used by default. This key should be provided during Api deployment. Mercure Hub should be publicly available so it is important to
configure ingress. Another one important thing to do is to configure CORS. See extraDirectives section. You have to add all
hostnames of deployed web apps (Patient app, Doctor app, Nurse app, Manager app and Assistant app). Example of values to override:

<pre>
publisherJwtKey: "some secret value"
subscriberJwtKey: "some secret value"
image:
  tag: "v0.13.0"
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-headers: "*"
    nginx.ingress.kubernetes.io/cors-allow-origin: "*"
  tls:
    - secretName: telemedicine-curamedon-mercure-prod-tls-cert
      hosts:
        - mercure.your.domain
  hosts:
    - host: "mercure.your.domain"
      paths:
        - path: "/"
          pathType: Prefix

extraDirectives: |-
  cors_origins "https://professionals.your.domain https://customers.your.domain https://assistants.your.domain https://nurses.your.domain https://managers.your.domain"
</pre>

### Application Setup
Once cluster is ready and all dependencies have been installed and configured we are ready to set up Curamedon applciations.
It consists of several services that should be deployed independently:
- [Api](curamedon-api/README.md)
- [Backoffice](curamedon-backoffice/README.md)
- [Uploads](curamedon-uploads/README.md)
- [Oauth 2 Server](curamedon-oauth/README.md)
- [Chat](curamedon-chat/README.md)
- [Web App for Patients](curamedon-customer-app/README.md)
- [Web App for Doctors](curamedon-professional-app/README.md)
- [Web App for Assistants](curamedon-assistant-app/README.md)
- [Web App for Nurses](curamedon-caregiver-app/README.md)
- [Web App for Nurse Managers](curamedon-manager-app/README.md)

Please follow links above to get deployment details

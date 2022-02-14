```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Inno Barn. All rights reserved.
```
# Curamedon Nurse Manager Web Application
## Introduction
This chart bootstraps a Curamedon Manager Web Application on a Kubernetes cluster using the Helm package manager.
This Helm chart was tested on Intel Smart Edge Open Kubernetes cluster (release 21.09).
## Prerequisites
- Kubernetes 1.20+
- Helm 3.1.0
- Installed and configured Curamedon API

## Installing the Chart
Prepare `values.override.yaml`. See `Parameters` section to find out which parameters
should be provided or overriden. To install the chart with the release name `manager-app`:


> helm install -n smartedge-apps -f values.override.yaml manager-app .

## Uninstalling the Manager App
To uninstall/delete the `manager-app` deployment:

> helm uninstall -n smartedge-apps manager-app

## Parameters

### Common parameters
| Name                                          | Description                                                                                                                                            | Default                                                                                 |
|:----------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| replicaCount                                  | Number of replicas to deploy                                                                                                                           | 1                                                                                       |
| autoscaling.enabled                           | Enable autoscaling                                                                                                                                     | false                                                                                   |
| autoscaling.minReplicas                       | Minimal number of replicas                                                                                                                             | 1                                                                                       |
| autoscaling.maxReplicas                       | Maximum number of replicas                                                                                                                             | 5                                                                                       |
| autoscaling.targetCPUUtilizationPercentage    | CPU Utilization threshold to deploy  one more replica                                                                                                  | 90                                                                                      |
| autoscaling.targetMemoryUtilizationPercentage | Memory Utilization threshold to deploy  one more replica                                                                                               | 80                                                                                      |
| podAnnotations                                | Custom annotations for pod                                                                                                                             | {}                                                                                      |
| podSecurityContext                            | Custom security context for pod                                                                                                                        | {}                                                                                      |
| securityContext                               | Custom security context for containers in pod                                                                                                          | {}                                                                                      |
| image.tag                                     | Version of the application image                                                                                                                       | 2.1.1                                                                                   |
| image.pullPolicy                              | Image pull policy: `IfNotPresent`, `Always` or `Never`                                                                                                 | IfNotPresent                                                                            |
| image.repository                              | Curamedon php image repository. In case of Smart Edge Open it is a repository in locally deployed Harbor registry                                      | ""                                                                                      |
| resources                                     | The resources limits and requested resources for php app container                                                                                     | {}                                                                                      |
| imagePullSecrets                              | Secrets to use in case of private docker registries                                                                                                    | []                                                                                      |
| nameOverride                                  | String to override curamedon-manager-app.name templat                                                                                                  | ""                                                                                      |
| fullnameOverride                              | String to override curamedon-manager-app.fullname template                                                                                             | ""                                                                                      |
| nodeSelector                                  | Node labels for pods assignment                                                                                                                        | {}                                                                                      |
| tolerations                                   | Tolerations for pods assignment                                                                                                                        | []                                                                                      |
| affinity                                      | Affinity for pods assignment                                                                                                                           | {}                                                                                      |
| serviceAccount.create                         | Enable the creation of a ServiceAccount for pods                                                                                                       | true                                                                                    |
| serviceAccount.annotations                    | Annotations for Service Account                                                                                                                        | {}                                                                                      |
| serviceAccount.name                           | Name of the created ServiceAccount                                                                                                                     | "2"                                                                                     |
| service.type                                  | K8S Service Type                                                                                                                                       | "ClusterIP"                                                                             |
| service.port                                  | K8S Service Port. Curamedon Web Apps exposes port 4200                                                                                                 | 4200                                                                                    |
| ingress.enabled                               | Deploy ingress rules                                                                                                                                   | true                                                                                    |
| ingress.className                             | Ingress class name. We use annotation to define ingress class name                                                                                     | ""                                                                                      |
| ingress.annotations                           | Ingress annotations. Ingress class and custer issuer should be defined here                                                                            | { kubernetes.io/igress.class: nginx \ cert-manager.io/cluster-issuer: letsencrypt-prod} |
| ingress.tls                                   | Ingress tls settings: secret name and all host names should be here                                                                                    | [{ secretName: telemedicine-curamedon-managers-prod-tls-cert \ hosts: []}]              |
| ingress.hosts                                 | Ingress hosts. A list of all hostnames should be here. `pathType: Prefix` and `path: "/"` should be used for all hosts. 7 hosts should be defined here | []                                                                                      |

### Application specific configuration parameters
| Name                        | Desciption                                                              | Default                                     |
|-----------------------------|-------------------------------------------------------------------------|---------------------------------------------|
| app.configs.apiUrl          | Hostname of API for Manager Web App. `https://managers-api.your.domain` | ""                                          |
| app.configs.chatUrl         | Chat web socket hostname. `wss://chat.your.domain`                      | ""                                          |
| app.configs.videoSdkUrl     | Url to load GCore Meet SDK                                              | "https://meet.econsult.lu/meetBridgeApi.js" |
| app.configs.environmentName | Environment name. Used as a environment name in `sentry.io`             | "openness"                                  |

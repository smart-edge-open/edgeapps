```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Inno Barn. All rights reserved.
```
# Curamedon Chat
## Introduction
This chart bootstraps a Curamedon Chat on a Kubernetes cluster using the Helm package manager.
This Helm chart was tested on Intel Smart Edge Open Kubernetes cluster (release 21.09).
## Prerequisites
- Kubernetes 1.20+
- Helm 3.1.0
- Installed and configured Curamedon API

## Installing the Chart
Prepare `values.override.yaml`. See `Parameters` section to find out which parameters
should be provided or overriden. To install the chart with the release name `chat`:

> helm install -n telemedicine -f values.override.yaml chat .

## Uninstalling the Chart
To uninstall/delete the `chat` deployment:

> helm uninstall -n telemedicine chat

## Parameters

### Common parameters
| Name                       | Description                                                                                                                                            | Default                                                                                 |
|:---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| podAnnotations             | Custom annotations for pod                                                                                                                             | {}                                                                                      |
| podSecurityContext         | Custom security context for pod                                                                                                                        | {}                                                                                      |
| securityContext            | Custom security context for containers in pod                                                                                                          | {}                                                                                      |
| image.tag                  | Version of the application image                                                                                                                       | 2.1.1                                                                                   |
| image.pullPolicy           | Image pull policy: `IfNotPresent`, `Always` or `Never`                                                                                                 | IfNotPresent                                                                            |
| image.repository           | Curamedon php image repository. In case of Smart Edge Open it is a repository in locally deployed Harbor registry                                      | ""                                                                                      |
| resources                  | The resources limits and requested resources for php app container                                                                                     | {}                                                                                      |
| imagePullSecrets           | Secrets to use in case of private docker registries                                                                                                    | []                                                                                      |
| nameOverride               | String to override curamedon-chat.name templat                                                                                                         | ""                                                                                      |
| fullnameOverride           | String to override curamedon-chat.fullname template                                                                                                    | ""                                                                                      |
| nodeSelector               | Node labels for pods assignment                                                                                                                        | {}                                                                                      |
| tolerations                | Tolerations for pods assignment                                                                                                                        | []                                                                                      |
| affinity                   | Affinity for pods assignment                                                                                                                           | {}                                                                                      |
| serviceAccount.create      | Enable the creation of a ServiceAccount for pods                                                                                                       | true                                                                                    |
| serviceAccount.annotations | Annotations for Service Account                                                                                                                        | {}                                                                                      |
| serviceAccount.name        | Name of the created ServiceAccount                                                                                                                     | "2"                                                                                     |
| service.type               | K8S Service Type                                                                                                                                       | "ClusterIP"                                                                             |
| service.port               | K8S Service Port. Curamedon Chat exposes port 80                                                                                                       | 80                                                                                      |
| ingress.enabled            | Deploy ingress rules                                                                                                                                   | true                                                                                    |
| ingress.className          | Ingress class name. We use annotation to define ingress class name                                                                                     | ""                                                                                      |
| ingress.annotations        | Ingress annotations. Ingress class and custer issuer should be defined here                                                                            | { kubernetes.io/igress.class: nginx \ cert-manager.io/cluster-issuer: letsencrypt-prod} |
| ingress.tls                | Ingress tls settings: secret name and all host names should be here                                                                                    | [{ secretName: telemedicine-curamedon-chat-prod-tls-cert \ hosts: []}]                  |
| ingress.hosts              | Ingress hosts. A list of all hostnames should be here. `pathType: Prefix` and `path: "/"` should be used for all hosts. 7 hosts should be defined here | []                                                                                      |

### Application specific configuration parameters
| Name                            | Desciption                                                             | Default |
|---------------------------------|------------------------------------------------------------------------|---------|
| app.configs.appEnv              | Application Environment name. `prod` or `dev`                          | prod    |
| app.configs.appHost             | Application host. `https://chat.your.domain`                           | ""      |
| app.configs.internalApiHost     | Host name of API for internal need. `https://internal-api.your.domain` | ""      |
| app.configs.metricsExporterPort | Port number for Prometheus metrics exporter                            | "9253"  |
| app.configs.jwtTtl              | JWT ttl                                                                | "300"   |

### Application specific secret parameters
| Name                             | Desciption                                                                                          | Default     |
|----------------------------------|-----------------------------------------------------------------------------------------------------|-------------|
| app.secrets.internalApiBasicAuth | Basic Auth credentials for chat service account to use to authenticate requests to the internal api | ""          |
| app.secrets.jwtPublicKeyContent  | Base 64 encoded content of JWT public key                                                           | ""          |

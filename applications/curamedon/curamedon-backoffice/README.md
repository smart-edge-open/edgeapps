```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Inno Barn. All rights reserved.
```
# Curamedon Backoffice
## Introduction
This chart bootstraps a Curamedon Backoffice on a Kubernetes cluster using the Helm package manager.
This Helm chart was tested on Intel Smart Edge Open Kubernetes cluster (release 21.09).
## Prerequisites
- Kubernetes 1.20+
- Helm 3.1.0
- Installed and configured MySQL
- Installed and configured Curamedon API

## Installing the Chart
Prepare `values.override.yaml`. See `Parameters` section to find out which parameters
should be provided or overriden. To install the chart with the release name `backoffice`:

> helm install -n smartedge-apps -f values.override.yaml backoffice .

## Uninstalling the Chart
To uninstall/delete the `backoffice` deployment:

> helm uninstall -n smartedge-apps backoffice

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
| imagePullSecrets                              | Secrets to use in case of private docker registries                                                                                                    | []                                                                                      |
| nameOverride                                  | String to override curamedon-backoffice.name template                                                                                                  | ""                                                                                      |
| fullnameOverride                              | String to override curamedon-backoffice.fullname template                                                                                              | ""                                                                                      |
| nodeSelector                                  | Node labels for pods assignment                                                                                                                        | {}                                                                                      |
| tolerations                                   | Tolerations for pods assignment                                                                                                                        | []                                                                                      |
| affinity                                      | Affinity for pods assignment                                                                                                                           | {}                                                                                      |
| php.image.repository                          | Curamedon php image repository. In case of Smart Edge Open it is a repository in locally deployed Harbor registry                                      | ""                                                                                      |
| php.resources                                 | The resources limits and requested resources for php app container                                                                                     | {}                                                                                      |
| nginx.image.repository                        | Curamedon nginx image repository. In case of Smart Edge Open it is a repository in locally deployed Harbor registry                                    | ""                                                                                      |
| nginx.resources                               | The resources limits and requested resources for nginx app container                                                                                   | {}                                                                                      |
| metrics.enabled                               | Enables sidecar container to collect metrics for Prometheus                                                                                            | false                                                                                   |
| metrics.image.repository                      | Exporter image repository                                                                                                                              | "hipages/php-fpm_exporter"                                                              |
| metrics.image.tag                             | Exporter image tag (immutable tags are recommended)                                                                                                    | "2"                                                                                     |
| serviceAccount.create                         | Enable the creation of a ServiceAccount for pods                                                                                                       | true                                                                                    |
| serviceAccount.annotations                    | Annotations for Service Account                                                                                                                        | {}                                                                                      |
| serviceAccount.name                           | Name of the created ServiceAccount                                                                                                                     | "2"                                                                                     |
| service.type                                  | K8S Service Type                                                                                                                                       | "ClusterIP"                                                                             |
| service.port                                  | K8S Service Port. Curamedon Backoffice exposes port 8080                                                                                               | 8080                                                                                    |
| ingress.enabled                               | Deploy ingress rules                                                                                                                                   | true                                                                                    |
| ingress.className                             | Ingress class name. We use annotation to define ingress class name                                                                                     | ""                                                                                      |
| ingress.annotations                           | Ingress annotations. Ingress class and custer issuer should be defined here                                                                            | { kubernetes.io/igress.class: nginx \ cert-manager.io/cluster-issuer: letsencrypt-prod} |
| ingress.tls                                   | Ingress tls settings: secret name and all host names should be here                                                                                    | [{ secretName: telemedicine-curamedon-backoffice-prod-tls-cert \ hosts: []}]            |
| ingress.hosts                                 | Ingress hosts. A list of all hostnames should be here. `pathType: Prefix` and `path: "/"` should be used for all hosts. 7 hosts should be defined here | []                                                                                      |
| mysqlServiceName                              | The fullname of the MySQL chart. Used to build DSN connection string                                                                                   | "curamedon-mysql"                                                                       |

### Application specific configuration parameters
| Name                                 | Desciption                                                                                                                  | Default         |
|--------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-----------------|
| app.configs.appEnv                   | Application Environment name. `prod` or `dev`                                                                               | prod            |
| app.configs.trustedHosts             | A list of trusted hostnames related to the Api. Use of regexp is allowed.                                                   | "^.+$$"         |
| app.configs.enableSmsTestMode        | If `1`, 2fa access code will be always equals to `1111`. If `0` random code will be generated                               | "0"             |
| app.configs.smsProvider              | Sms provide to send messaged. `test_provider` don't send real sms messages. `ring_ring` is available as a production option | "test_provider" |
| app.configs.internalApiHost          | Host name of API for internal need. `https://internal-api.your.domain`                                                      | ""              |
| app.configs.environmentName          | Environment name. Used as a environment name in `sentry.io`                                                                 | "openness"      |
| app.configs.enable2Fa                | Enable Two Factor authentication. SMS provider must be configured smsTestMode should be disabled                            | "0"             |
| app.configs.enableDatabaseEncryption | If `1` encription for some sensetive fields will be enabled.                                                                | "1"             |
| app.configs.googleAnalyticsCacheTtl  | Cache TTL in minutes for Google Analytics api                                                                               | "5"             |
### Application specific secret parameters
| Name                                         | Desciption                                                                                                | Default     |
|----------------------------------------------|-----------------------------------------------------------------------------------------------------------|-------------|
| app.secrets.appSecret                        | Random string. Used for csrf generation and other internal needs                                          | ""          |
| app.secrets.dbUser                           | MySQL database username                                                                                   | ""          |
| app.secrets.dbPassword                       | MySQL database password                                                                                   | ""          |
| app.secrets.dbName                           | MySQL database name                                                                                       | "curamedon" |
| app.secrets.databaseEncryptionKey            | Database encryption key.                                                                                  | ""          |
| app.secrets.internalApiBasicAuth             | Basic Auth credentials for backoffice service account to use to authenticate requests to the internal api | ""          |
| app.secrets.ringRingApiKey                   | Api key for Ring Ring SMS provider                                                                        | ""          |
| app.secrets.luxembourgRingRingApiKey         | Luxembourg specific Api key for Ring Ring SMS provider.                                                   | ""          |
| app.secrets.telegramLogApiKey                | Api key for Telegram Bot. Used as a logger channel                                                        | ""          |
| app.secrets.telegramLogChannel               | Telegram channel ID for logs                                                                              | ""          |
| app.secrets.sentryDsn                        | Sentry.io DSN connection string                                                                           | ""          |
| app.secrets.googleServiceAccountCredsContent | Base 64 encoded Google API service account credentials                                                    | ""          |
| app.secrets.googleAnalyticsProfileId         | Google Analytics API profile Id                                                                           | ""          |



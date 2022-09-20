```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Inno Barn. All rights reserved.
```
# Curamedon Uploads
## Introduction
This chart bootstraps a Curamedon Uploads on a Kubernetes cluster using the Helm package manager.
This Helm chart was tested on Intel Smart Edge Open Kubernetes cluster (release 21.09).
## Prerequisites
- Kubernetes 1.20+
- Helm 3.1.0
- Installed and configured MySQL
- Installed and configured Curamedon API

## Installing the Chart
Prepare `values.override.yaml`. See `Parameters` section to find out which parameters
should be provided or overriden. To install the chart with the release name `uploads`:

> helm install -n smartedge-apps -f values.override.yaml uploads .

## Uninstalling the Chart
To uninstall/delete the `uploads` deployment:

> helm uninstall -n smartedge-apps uploads

## Parameters

### Common parameters
| Name                       | Description                                                                                                                                            | Default                                                                                 |
|:---------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| replicaCount               | Number of replicas to deploy                                                                                                                           | 1                                                                                       |
| podAnnotations             | Custom annotations for pod                                                                                                                             | {}                                                                                      |
| podSecurityContext         | Custom security context for pod                                                                                                                        | {}                                                                                      |
| securityContext            | Custom security context for containers in pod                                                                                                          | {}                                                                                      |
| image.tag                  | Version of the application image                                                                                                                       | 2.1.1                                                                                   |
| image.pullPolicy           | Image pull policy: `IfNotPresent`, `Always` or `Never`                                                                                                 | IfNotPresent                                                                            |
| imagePullSecrets           | Secrets to use in case of private docker registries                                                                                                    | []                                                                                      |
| nameOverride               | String to override curamedon-uploads.name templat                                                                                                      | ""                                                                                      |
| fullnameOverride           | String to override curamedon-uploads.fullname template                                                                                                 | ""                                                                                      |
| nodeSelector               | Node labels for pods assignment                                                                                                                        | {}                                                                                      |
| tolerations                | Tolerations for pods assignment                                                                                                                        | []                                                                                      |
| affinity                   | Affinity for pods assignment                                                                                                                           | {}                                                                                      |
| php.image.repository       | Curamedon php image repository. In case of Smart Edge Open it is a repository in locally deployed Harbor registry                                      | ""                                                                                      |
| php.resources              | The resources limits and requested resources for php app container                                                                                     | {}                                                                                      |
| nginx.image.repository     | Curamedon nginx image repository. In case of Smart Edge Open it is a repository in locally deployed Harbor registry                                    | ""                                                                                      |
| nginx.resources            | The resources limits and requested resources for nginx app container                                                                                   | {}                                                                                      |
| metrics.enabled            | Enables sidecar container to collect metrics for Prometheus                                                                                            | false                                                                                   |
| metrics.image.repository   | Exporter image repository                                                                                                                              | "hipages/php-fpm_exporter"                                                              |
| metrics.image.tag          | Exporter image tag (immutable tags are recommended)                                                                                                    | "2"                                                                                     |
| serviceAccount.create      | Enable the creation of a ServiceAccount for pods                                                                                                       | true                                                                                    |
| serviceAccount.annotations | Annotations for Service Account                                                                                                                        | {}                                                                                      |
| serviceAccount.name        | Name of the created ServiceAccount                                                                                                                     | "2"                                                                                     |
| service.type               | K8S Service Type                                                                                                                                       | "ClusterIP"                                                                             |
| service.port               | K8S Service Port. Curamedon Uploads exposes port 8000                                                                                                  | 8000                                                                                    |
| ingress.enabled            | Deploy ingress rules                                                                                                                                   | true                                                                                    |
| ingress.className          | Ingress class name. We use annotation to define ingress class name                                                                                     | ""                                                                                      |
| ingress.annotations        | Ingress annotations. Ingress class and custer issuer should be defined here                                                                            | { kubernetes.io/igress.class: nginx \ cert-manager.io/cluster-issuer: letsencrypt-prod} |
| ingress.tls                | Ingress tls settings: secret name and all host names should be here                                                                                    | [{ secretName: telemedicine-curamedon-uploads-prod-tls-cert \ hosts: []}]               |
| ingress.hosts              | Ingress hosts. A list of all hostnames should be here. `pathType: Prefix` and `path: "/"` should be used for all hosts. 7 hosts should be defined here | []                                                                                      |
| persistence.enabled        | Enable persistence on replicas using a `PersistentVolumeClaim`. If false, uses emptyDir                                                                | true                                                                                    |
| persistence.existingClaim  | Name of an existing `PersistentVolumeClaim` for replicas                                                                                               | ""                                                                                      |
| persistence.storageClass   | Persistent volume storage Class                                                                                                                        | ""                                                                                      |
| persistence.annotations    | Persistent volume claim annotations                                                                                                                    | {}                                                                                      |
| persistence.accessModes    | Persistent volume access Modes                                                                                                                         | ["ReadWriteOnce"]                                                                       |
| persistence.size           | Persistent volume size                                                                                                                                 | 8Gi                                                                                     |
| persistence.selector       | Selector to match an existing Persistent Volume                                                                                                        | {}                                                                                      |
| antivirus.enabled          | Enable or disable deploying antivirus container                                                                                                        | false                                                                                   |
| antivirus.image.repository | Antivirus image repository                                                                                                                             | mailu/clamav                                                                            |
| antivirus.image.tag        | Version of the antivirus image                                                                                                                         | 1.9                                                                                     |
| antivirus.image.pullPolicy | Antivirus Image pull policy: `IfNotPresent`, `Always` or `Never`                                                                                       | IfNotPresent                                                                            |
| antivirus.resources        | The resources limits and requested resources for antivirus app container                                                                               | {}                                                                                      |

### Application specific configuration parameters
| Name                        | Desciption                                                                                                                                   | Default                              |
|-----------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------|
| app.configs.appEnv          | Application Environment name. `prod` or `dev`                                                                                                | prod                                 |
| app.configs.trustedHosts    | A list of trusted hostnames related to the Uploads. Use of regexp is allowed.                                                                | "^.+$$"                              |
| app.configs.corsAllowOrigin | A list of hostnames that are allowed to send cross-origin requests. Use of regexp is allowed. Should match all Curamedon Web Apps hostnames. | "^.+$$"                              |
| app.configs.internalApiHost | Host name of API for internal needs. `internal-api.your.domain`                                                                              | ""                                   |
| app.configs.environmentName | Environment name. Used as a environment name in `sentry.io`                                                                                  | "openness"                           |
| app.configs.jwtTtl          | Access Token TTL in seconds                                                                                                                  | "300"                                |
| app.configs.storageClass    | Type of storage to use. `App\Service\Storage\LocalFileStorage` and `App\Service\Storage\S3FileStorage` are available                         | App\Service\Storage\LocalFileStorage |
| app.configs.scanForViruses  | Enable or disable antivirus. Available for `App\Service\Storage\LocalFileStorage` only                                                       | "0"                                  |
| app.configs.s3Endpoint      | S3 compatible storage endpoint (hostname)                                                                                                    | ""                                   |
| app.configs.s3PrivateBucket | S3 bucket name for private files                                                                                                             | ""                                   |
| app.configs.s3PublicBucket  | S3 bucket name for public files                                                                                                              | ""                                   |

### Application specific secret parameters
| Name                             | Desciption                                                                                         | Default     |
|----------------------------------|----------------------------------------------------------------------------------------------------|-------------|
| app.secrets.appSecret            | Random string. Used for csrf generation and other internal needs                                   | ""          |
| app.secrets.jwtPassphrase        | Passphrase for JWT Private Key                                                                     | ""          |
| app.secrets.jwtPublicKeyContent  | Base 64 encoded content of JWT public key                                                          | ""          |
| app.secrets.jwtPrivateKeyContent | Base 64 encoded content of JWT private key                                                         | ""          |
| app.secrets.internalApiBasicAuth | Basic Auth credentials for uploads service account to use to authenticate requests to internal api ||
| app.secrets.telegramLogApiKey    | Api key for Telegram Bot. Used as a logger channel                                                 | ""          |
| app.secrets.telegramLogChannel   | Telegram channel ID for logs                                                                       | ""          |
| app.secrets.sentryDsn            | Sentry.io DSN connection string                                                                    | ""          |
| app.secrets.s3AccessKey          | S3 access key                                                                                      | ""          |
| app.secrets.s3SecretKey          | S3 secret key                                                                                      | ""          |

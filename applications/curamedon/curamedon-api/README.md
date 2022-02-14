```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Inno Barn. All rights reserved.
```
# Curamedon API
## Introduction
This chart bootstraps a Curamedon API on a Kubernetes cluster using the Helm package manager.
This Helm chart was tested on Intel Smart Edge Open Kubernetes cluster (release 21.09).
## Prerequisites
- Kubernetes 1.20+
- Helm 3.1.0
- Installed and configured MySQL
- Installed and configured Redis
- Installed and configured Elasticsearch
- Installed and configured Mercure Hub

## Installing the Chart
Prepare `values.override.yaml`. See `Parameters` section to find out which parameters
should be provided or overriden. To install the chart with the release name `api`:

> helm install -n smartedge-apps -f values.override.yaml api .

## Uninstalling the Chart
To uninstall/delete the `api` deployment:

> helm uninstall -n smartedge-apps api

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
| nameOverride                                  | String to override curamedon-api.name templat                                                                                                          | ""                                                                                      |
| fullnameOverride                              | String to override curamedon-api.fullname template                                                                                                     | ""                                                                                      |
| nodeSelector                                  | Node labels for pods assignment                                                                                                                        | {}                                                                                      |
| tolerations                                   | Tolerations for pods assignment                                                                                                                        | []                                                                                      |
| affinity                                      | Affinity for pods assignment                                                                                                                           | {}                                                                                      |
| consumer.replicaCount                         | Minimal number of replicas  for queue consumer                                                                                                         | 1                                                                                       |
| consumer.podAnnotations                       | Custom annotations for consumer pod                                                                                                                    | {}                                                                                      |
| consumer.podSecurityContext                   | Custom security context for consumer pod                                                                                                               | {}                                                                                      |
| consumer.securityContext                      | Custom security context for containers in consumer pod                                                                                                 | {}                                                                                      |
| consumer.resources                            | The resources limits and requested resources for consumer container                                                                                    | {}                                                                                      |
| consumer.nodeSelector                         | Node labels for consumer pods assignment                                                                                                               | {}                                                                                      |
| consumer.tolerations                          | Tolerations for consumer pods assignment                                                                                                               | []                                                                                      |
| consumer.affinity                             | Affinity for consumer pods assignment                                                                                                                  | {}                                                                                      |
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
| service.port                                  | K8S Service Port. Curamedon Api exposes port 8000                                                                                                      | 8000                                                                                    |
| ingress.enabled                               | Deploy ingress rules                                                                                                                                   | true                                                                                    |
| ingress.className                             | Ingress class name. We use annotation to define ingress class name                                                                                     | ""                                                                                      |
| ingress.annotations                           | Ingress annotations. Ingress class and custer issuer should be defined here                                                                            | { kubernetes.io/igress.class: nginx \ cert-manager.io/cluster-issuer: letsencrypt-prod} |
| ingress.tls                                   | Ingress tls settings: secret name and all host names should be here                                                                                    | [{ secretName: telemedicine-curamedon-api-prod-tls-cert \ hosts: []}]                   |
| ingress.hosts                                 | Ingress hosts. A list of all hostnames should be here. `pathType: Prefix` and `path: "/"` should be used for all hosts. 7 hosts should be defined here | []                                                                                      |
| mysqlServiceName                              | The fullname of the MySQL chart. Used to build DSN connection string                                                                                   | "curamedon-mysql"                                                                       |
| redisServiceName                              | The fullname of the Redis chart. Used to build DSN connection string                                                                                   | "curamedon-redis"                                                                       |
| elasticsearchServiceName                      | The fullname of the Elasticsearch chart. Used to build DSN connection string                                                                           | "curamedon-elastcisearch"                                                               |

### Application specific configuration parameters
| Name                                                      | Desciption                                                                                                                                   | Default                    |
|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| app.configs.appEnv                                        | Application Environment name. `prod` or `dev`                                                                                                | prod                       |
| app.configs.appName                                       | Application name. Displayed on Api Documentation                                                                                             | "Curamedon API"            |
| app.configs.trustedHosts                                  | A list of trusted hostnames related to the Api. Use of regexp is allowed.                                                                    | ".+$$"                     |
| app.configs.corsAllowOrigin                               | A list of hostnames that are allowed to send cross-origin requests. Use of regexp is allowed. Should match all Curamedon Web Apps hostnames. | ".+$$"                     |
| app.configs.mercurePubSubUrl                              | Publically available host name of Mercure Hub (with schema)                                                                                  | ""                         |
| app.configs.enableSmsTestMode                             | If `1`, 2fa access code will be always equals to `1111`. If `0` random code will be generated                                                | "0"                        |
| app.configs.smsProvider                                   | Sms provide to send messaged. `test_provider` don't send real sms messages. `ring_ring` is available as a production option                  | "test_provider"            |
| app.configs.customerApiHost                               | Host name of API for Patients Web App. Should not include schema. `customers-api.your.domain`                                                | ""                         |
| app.configs.professionalApiHost                           | Host name of API for Doctors Web App. Should not include schema. `professionals-api.your.domain`                                             | ""                         |
| app.configs.caregiverApiHost                              | Host name of API for Nurses Web App. Should not include schema. `nurses-api.your.domain`                                                     | ""                         |
| app.configs.managerApiHost                                | Host name of API for Nurse Managers Web App. Should not include schema. `managers-api.your.domain`                                           | ""                         |
| app.configs.assistantApiHost                              | Host name of API for Assistants Web App. Should not include schema. `assistants-api.your.domain`                                             | ""                         |
| app.configs.internalApiHost                               | Host name of API for internal need. Used by another services. Should not include schema. `internal-api.your.domain`                          | ""                         |
| app.configs.webHooksHost                                  | Host name for webhooks. Used external calendars to send push notifications. Should not include schema. `webhooks.your.domain`                | ""                         |
| app.configs.uploadsServiceHost                            | Host name of Curamedon Uploads. `https://uploads.your.domain`                                                                                | ""                         |
| app.configs.publicAssetsHost                              | Host name for public assets. Own or 3rd party web server might be used. logo, favicon, background image are loaded from that server.         | ""                         |
| app.configs.videoCallHost                                 | Host name of the GCore Meet video service                                                                                                    | "https://meet.econsult.lu" |
| app.configs.videoCallWebsocketHost                        | Websocket host of the GCore Meet video service                                                                                               | "meet-backend.econsult.lu" |
| app.configs.environmentName                               | Environment name. Used as a environment name in `sentry.io`                                                                                  | "openness"                 |
| app.configs.jwtTtl                                        | Access Token TTL in seconds                                                                                                                  | "300"                      |
| app.configs.jwtRefreshTtl                                 | Refresh Token TTL in seconds                                                                                                                 | "1800"                     |
| app.configs.appointmentRequestTtl                         | Duration in seconds for ignoring multiple request from one patient                                                                           | "86400"                    |
| app.configs.supportEmail                                  | Email of the support team                                                                                                                    | ""                         |
| app.configs.noReplyEmail                                  | No-reply  email                                                                                                                              | ""                         |
| app.configs.salesEmail                                    | Email of the sales team                                                                                                                      | ""                         |
| app.configs.enableApiDocumentation                        | Enable Swager UI with Api documentation                                                                                                      | "1"                        |
| app.configs.enable2Fa                                     | Enable Two Factor authentication. SMS provider must be configured smsTestMode should be disabled                                             | "0"                        |
| app.configs.firebaseDomain                                | Domain name for Firebase short links                                                                                                         | ""                         |
| app.configs.availabilityBeforeConsultationStart           | Time (in minutes) before appointment video call becomes available                                                                            | "10"                       |
| app.configs.prescriptionEndpoint                          | Endpoint for Prescription microservice. Feature should be enabled in backoffice                                                              | ""                         |
| app.configs.prescriptionMicroserviceSource                | Application identifier for prescription microservice                                                                                         | "Openness"                 |
| app.configs.externalCalendarManualRefreshAwaitanceSeconds | Period of time user is able to manually synchronize their external calendar                                                                  | "60"                       |
| app.configs.enableDatabaseEncryption                      | If `1` encription for some sensetive fields will be enabled.                                                                                 | "1"                        |
| app.configs.emailActionButtonBackgroundColour             | Background color for buttons in emails                                                                                                       | "0075FF"                   |

### Application specific secret parameters
| Name                                          | Desciption                                                                                     | Default     |
|-----------------------------------------------|------------------------------------------------------------------------------------------------|-------------|
| app.secrets.appSecret                         | Random string. Used for scrf generation and other internal needs                               | ""          |
| app.secrets.dbUser                            | MySQL database username                                                                        | ""          |
| app.secrets.dbPassword                        | MySQL database password                                                                        | ""          |
| app.secrets.dbName                            | MySQL database name                                                                            | "curamedon" |
| app.secrets.databaseEncryptionKey             | Database encryption key.                                                                       | ""          |
| app.secrets.mailerUrl                         | Mailer DSN connection string                                                                   | ""          |
| app.secrets.jwtPassphrase                     | Passphrase for JWT Private Key                                                                 | ""          |
| app.secrets.jwtPublicKeyContent               | Base 64 encoded content of JWT public key                                                      | ""          |
| app.secrets.jwtPrivateKeyContent              | Base 64 encoded content of JWT private key                                                     | ""          |
| app.secrets.mercureJwtKey                     | HS256 key for Mercure Hub                                                                      | ""          |
| app.secrets.ringRingApiKey                    | Api key for Ring Ring SMS provider                                                             | ""          |
| app.secrets.luxembourgRingRingApiKey          | Luxembourg specific Api key for Ring Ring SMS provider.                                        | ""          |
| app.secrets.gcoreMeetUserPassword             | Hashed password for GCore meet service account. `bin/console security:hash-password`           | ""          |
| app.secrets.backooficeAppUserPassword         | Hashed password for Curamedon Backoffice service account. `bin/console security:hash-password` | ""          |
| app.secrets.chatAppUserPassword               | Hashed password for Curamedon Chat service account. `bin/console security:hash-password`       | ""          |
| app.secrets.uploadsAppUserPassword            | Hashed password for Curamedon Uploads service account. `bin/console security:hash-password`    | ""          |
| app.secrets.telegramLogApiKey                 | Api key for Telegram Bot. Used as a logger channel                                             | ""          |
| app.secrets.telegramLogChannel                | Telegram channel ID for logs                                                                   | ""          |
| app.secrets.oauth2PrivateKeyPassphrase        | Passphrase for Oauth 2 Private Key                                                             | ""          |
| app.secrets.oauth2PublicKeyContent            | Base 64 encoded content of Oauth 2 public key                                                  | ""          |
| app.secrets.oauth2PrivateKeyContent           | Base 64 encoded content of Oauth 2 private key                                                 | ""          |
| app.secrets.oauth2EncryptionKey               | Oauth 2 encryption key                                                                         | ""          |
| app.secrets.googleApiKey                      | Google Calendar API Key                                                                        | ""          |
| app.secrets.googleApiClientId                 | Google Calendar API client ID                                                                  | ""          |
| app.secrets.googleApiClientSecret             | Google Calendar API client Secret                                                              | ""          |
| app.secrets.microsoftClientIdProfessional     | MS Office 365 Calendar API client ID for Doctors web app                                       | ""          |
| app.secrets.microsoftClientSecretProfessional | MS Office 365 Calendar API client Secret for Doctor web app                                    | ""          |
| app.secrets.microsoftClientIdNurse            | MS Office 365 Calendar API client ID for Nurses web app                                        | ""          |
| app.secrets.microsoftClientSecretNurse        | MS Office 365 Calendar API client Secret for Nurses web app                                    | ""          |
| app.secrets.sentryDsn                         | Sentry.io DSN connection string                                                                | ""          |
| app.secrets.googleMapsGeocodeApiKey           | Google Maps Geocode Api Key                                                                    | ""          |
| app.secrets.firebaseApiKey                    | Firebase Api key (for short link generator)                                                    | ""          |

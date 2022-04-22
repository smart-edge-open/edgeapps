```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Frinx s. r. o.
```

## FRINX-machine

FRINX Machine is a dockerized deployment of multiple elements. The FRINX Machine enables large scale automation of network devices, services and retrieval of operational state data from a network. User specific workflows are designed through the use of OpenConfig NETCONF & YANG models, vendor native models, and the CLI. The FRINX Machine uses dockerized containers that are designed and tested to work together to create a user specific solution. Further information is available on [docs.frinx.io](https://docs.frinx.io/frinx-machine/getting-started/). 

## Install Chart

```console
helm install [RELEASE_NAME] <helm-chart-location>
```

## Upgrading Chart

```console
helm upgrade [RELEASE_NAME] <helm-chart-location>
```

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```

## Dependencies

| Chart | Documentation |
|-----------|-------------|
| `krakend` | [ArtifactHub](https://artifacthub.io/packages/helm/frinx-helm-charts/krakend) |
| `frinx-frontend` | [ArtifactHub](https://artifacthub.io/packages/helm/frinx-helm-charts/frinx-frontend) |
| `postgresql` | [ArtifactHub](https://artifacthub.io/packages/helm/bitnami/postgresql) |
| `uniresource` | [ArtifactHub](https://artifacthub.io/packages/helm/frinx-helm-charts/uniresource) |
| `uniflow` | [ArtifactHub](https://artifacthub.io/packages/helm/frinx-helm-charts/uniflow) |
| `inventory` | [ArtifactHub](https://artifacthub.io/packages/helm/frinx-helm-charts/inventory) |
| `uniconfig-postgresql` | [ArtifactHub](https://artifacthub.io/packages/helm/bitnami/postgresql) |
| `uniconfig` | [ArtifactHub](https://artifacthub.io/packages/helm/frinx-helm-charts/uniconfig) |
| `demo-workflows` | [ArtifactHub](https://artifacthub.io/packages/helm/frinx-helm-charts/demo-workflows) |

## **Pre Requisites – Resources Required**

| **Resource Information**           |                      |
|------------------------------------|----------------------| 
| Compute  (vCores)                  | 8                    |  
| Memory (RAM)                       | 24 GB                |  
| Storage 				             | 40 GB                |

## License

A 30-day trial license of UniConfig is included, if you would like to change the license, replace the license string in values.yaml `uniconfig.license` env variable with your own.

## Where to Purchase

For information regarding sales, visit [frinx.io](https://frinx.io/) or contact us at info@frinx.io

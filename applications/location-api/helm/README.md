```text
SSPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 LINKS Foundation
``` 

Example command for installing location-api with helm charts


```sh
helm install links-location-api links-location-api/ --values links-location-api/values.yaml --set env[0].name=NODE_IP --set env[0].value="<edge-node-ip>" --set env[1].name=NODE_PORT_SIMULATOR --set env[1].value="<edge-node-port>"
```
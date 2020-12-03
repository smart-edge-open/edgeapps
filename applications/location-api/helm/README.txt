Example command for installing location-api with helm charts..

1) Will expose location API simulator to 10.10.20.28:30556
    --> helm install  links-location-api links-location-api/ --values links-location-api/values.yaml

2) To set different environmental variables 
    --> helm install links-location-api links-location-api/ --values links-location-api/values.yaml --set env[0].name=NODE_IP --set env[0].value="<edge-node-ip>" --set env[1].name=NODE_PORT_SIMULATOR --set env[1].value="<edge-node-port>"

```text
Copyright (c) 2020 ClearBlade, Inc. All rights reserved.
```
# ClearBlade Overview
ClearBlade is the industry-leading Edge Computing software company that enables enterprises to rapidly engineer and run secure, real-time, scalable IoT applications. Headquartered in Austin, Texas, ClearBlade is an award-winning, fully scalable, secure, flexible, and autonomous IoT edge platform that enables companies to ingest, analyze, adapt and act on any data in real-time and at extreme scale. ClearBlade provides a consistent platform across the edge, cloud, and on-premise environments. 

For more information on ClearBlade please visit [ClearBlade's website](https://www.clearblade.com/).

# Application Overview
ClearBlade Edge is an application to synchronize, configure, manage, and deploy IoT systems. It is designed to perform well on a constrained hardware platform and be managed and updated remotely post-deployment.
The ClearBlade Edge contains all the same features of the ClearBlade Platform and is designed to be deployed in remote networks to interact with sensors, controllers, and industrial systems.

## Deploying the ClearBlade Edge

### Loading Docker Images
Pull and load the appropriate ClearBlade Edge release found at https://hub.docker.com/r/clearblade/edge/tags

The ClearBlade container images can be loaded using the following commands:
```shell
  docker pull clearblade/edge:9.7.0
  docker image load -I clearblade/edge:9.7.0
```

The Helm charts for deploying these images are located at https://github.com/open-ness/edgeapps/tree/master/applications/clearblade-edge and should be copied to the controller for deployment.

### Installing the ClearBlade Edge chart

Run the following commands to deploy an instance of the ClearBlade Edge through helm:
```shell
cd edgeapps/applications/clearblade-edge/ 
helm install myclearbladechart clearbladehelm/
```

```shell
$ cd edgeapps/applications/clearblade-edge/
$ helm install myclearbladechart clearbladehelm/
NAME: myclearbladechart
LAST DEPLOYED: Tue Dec  1 16:19:35 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

$ kubectl get all
NAME                 READY   STATUS    RESTARTS   AGE
pod/intelopenness2   1/1     Running   0          56m

NAME                       TYPE        CLUSTER-IP      EXTERNAL-IP      PORT(S)          AGE
service/clearblade-edge2   NodePort    10.109.166.66   <none>           9000:31108/TCP   56m
```

## Uninstalling ClearBlade Edge
```shell
helm uninstall myclearbladechart
```

## Additional Information
Learn more about ClearBlade Edge computing at https://www.clearblade.com
For purchasing info please reach out to sales@clearblade.com or cbeauchamp@clearblade.com

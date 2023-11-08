# edge-helm-chart

Helm chart for edge 

## Sample command with no edgeml:
`helm install edge . --set fhm.endpoint=192.168.56.142 --set edgeName=lightning-edge --namespace foghorn --create-namespace`

## Sample command with ADVANCED3 edgeml:
`helm install edge . --set fhm.endpoint=192.168.56.142 --set edgeName=lightning-edge --set edgeml.type=ADVANCED3 --namespace foghorn --create-namespace`

## Sample command with ADVANCED3 edgeml and arm32 architecture:
`helm install edge . --set fhm.endpoint=192.168.56.142 --set edgeName=lightning-edge --set edgeml.type=ADVANCED3 --set image.arch=-armv7l --namespace foghorn --create-namespace`

## Sample command dry run:
`helm install edge . --set fhm.endpoint=192.168.56.142 --set edgeName=lightning-edge --dry-run --namespace foghorn --create-namespace`

## Sample command to cleanup leftover resources manually
`kubectl delete service,deployment,job,pod,configmap,secret,pvc,pv,rolebinding,clusterrolebinding,role,clusterrole,sa -ledge.foghorn.io/managed-by=edge --namespace foghorn`

## Sample command to cleanup pv and pvc that are stuck in terminating state
`kubectl patch pvc foghorn -p '{"metadata":{"finalizers":null}} --namespace foghorn`

## Create Local Persistent Volumes(Not recommended in Production - workaround for test deployments)
Most deployments have default storageclass and provisioner already set like k3s, aks, gke etc. Incase it is not, please request cluster administrator to do so. A default storageclass and dynamic provisioner would make it easier to create and bind persistentvolumes to persistentvolumeclaims automatically. In case, a cluster does not have provisioner, the following yaml snippet can be applied to create perisistentvolumes manually. Add the snippet to a file and apply it using `kubectl apply -f <file name>`.


    ---
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: influx-data
      namespace: foghorn
      labels:
        type: local
    spec:
      storageClassName: manual
      capacity:
        storage: 10Gi
      accessModes:
        - ReadWriteOnce
      hostPath:
        path: "/opt/influx-data"

    ---
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: foghorn
      namespace: foghorn
      labels:
        type: local
    spec:
      storageClassName: manual
      capacity:
        storage: 10Gi
      accessModes:
        - ReadWriteOnce
      hostPath:
        path: "/opt/foghorn-data"
    ---

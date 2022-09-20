#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Exium Inc.

#shellcheck disable=2154 

script_dir="$(dirname "$0")"

# shellcheck disable=SC1091
source "${script_dir}/precheck.sh"

# shellcheck disable=SC1091
source "${script_dir}/config.sh"

# shellcheck disable=SC1091
source "${script_dir}/lib/exium-config.sh"

#########                                                                             
# Install Istio                                                                       
########           
istioctl manifest apply -f lib/istioctl_default_exedge.yaml
                

###########
# Setup NFS
##########
yum install -y nfs-utils
systemctl start nfs-server rpcbind
systemctl enable nfs-server rpcbind
mkdir -p /srv/nfs/exium
chmod -R 777 /srv/nfs/
cp /etc/exports /etc/exports."$(date +%F_%R)"
echo "/srv/nfs/exium  *(rw,sync,no_subtree_check,no_root_squash,insecure)" > /etc/exports
exportfs -rv
showmount -e


###########
# Setup NFS StorageClass
###########
nodeExternalIP=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install --wait nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
 --set nfs.server="${nodeExternalIP}" \
 --set nfs.path=/srv/nfs/exium \
 --set storageClass.defaultClass=true


##########
# exopsagent namespace
##########
kubectl create namespace exopsagent
kubectl label namespace exopsagent istio-injection=enabled
kubectl -n exopsagent apply -f lib/service-account-xe.yaml
kubectl patch serviceaccount default  -p "{\"imagePullSecrets\": [{\"name\": \"service-account-xe\"}]}" -n exopsagent

##########
# redis
##########
helm upgrade --install --wait --namespace=exopsagent redis stable/redis \
 --set image.registry='gcr.io' \
 --set image.repository='ec2nf-256816/redis' \
 --set image.tag='5.0.7-debian-10-r32' \
 -f lib/redis_overrides.yaml


sleep 60

##########
# production namespace
##########
kubectl create namespace production
kubectl label namespace production istio-injection=enabled
kubectl -n production apply -f lib/service-account-xe.yaml
kubectl patch serviceaccount default  -p "{\"imagePullSecrets\": [{\"name\": \"service-account-xe\"}]}" -n production


##########
# upf-n4fe
##########
helm upgrade --install upf-n4fe helm/upf-n4fe --namespace production  --set env.natsServer="nats://nats-client.exopsagent:4222"


##########
# n3iwf-eap5g
##########
helm upgrade --install n3iwf-eap5g helm/n3iwf-eap5g --namespace production \
 --set env.exedgeName="${exedge_name}"  \
 --set env.n3iwfName="${exedge_name}" \
 --set env.fluentServer="fluentd.production" \
 --set env.natsServer="nats://nats-client.exopsagent:4222"

##########
# exe-health
##########
helm upgrade --install --wait --namespace production exe-health helm/exe-health \
 --set env.exedgeName="${exedge_name}" \
 --set env.natsServer="nats://nats-client.exopsagent:4222" \
 --set env.xOpsUrl="${xops_url}"

############
# n3iwf-n2fe
############

helm upgrade --install --namespace production n3iwf-n2fe helm/n3iwf-n2fe \
 --set env.fluentServer="fluentd.production" \
 --set env.n2fePort="${n2fe_port}" 

############
# LB patch for Non-cloud setup
##########
nodeCount=$(kubectl get node| wc -l)
if [ "$nodeCount" -ne 2 ]
then
	echo "Cluster has more than 1 nodes. Setup may not work properly. Please contact Exium" 
        exit 1
else
  nodeExternalIP=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
  kubectl patch svc ilb-gateway -n istio-system -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
  kubectl patch svc istio-ingressgateway -n istio-system -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
  kubectl patch svc n3iwf-eap5g-udp -n production -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
  kubectl patch svc upf-n4fe-pfcp -n production -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
fi


#########
# configure xcore
#########
# Contact xedge sales team

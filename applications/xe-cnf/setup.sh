# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Exium Inc.

script_dir="$(dirname "$0")"

source ${script_dir}/precheck.sh
source ${script_dir}/config.sh
source ${script_dir}/lib/exium-config.sh

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
cp /etc/exports /etc/exports.$(date +%F_%R)
echo "/srv/nfs/exium  *(rw,sync,no_subtree_check,no_root_squash,insecure)" > /etc/exports
exportfs -rv
showmount -e


###########
# Setup NFS StorageClass
###########
nodeExternalIP=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm install --wait nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
 --set nfs.server=${nodeExternalIP} \
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

#########
# nats
#########
kubectl label namespace exopsagent istio-injection-
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm upgrade --install --namespace=exopsagent  nats bitnami/nats \
  --set image.registry='gcr.io' \
  --set image.repository='ec2nf-256816/nats' \
  --set image.tag='2.2.5-debian-10-r2' \
  -f lib/nats_service_annos.yaml
kubectl label namespace exopsagent istio-injection=enabled

##########
# cfgagent
##########
helm upgrade --install --wait exmw-cfgagent helm/exmw-cfgagent --namespace=exopsagent  \
 --set env.cfgNodeName=${exedge_name} \
 --set env.exopsNatsUrl=${exops_nats}

##########
# subagent
##########
helm upgrade --install --wait exmw-subagent helm/exmw-subagent --namespace=exopsagent \
 --set env.cfgNodeName=${exedge_name} \
 --set env.exopsNatsUrl=${exops_nats}

sleep 60

##########
# production namespace
##########
kubectl create namespace production
kubectl label namespace production istio-injection=enabled
kubectl -n production apply -f lib/service-account-xe.yaml
kubectl patch serviceaccount default  -p "{\"imagePullSecrets\": [{\"name\": \"service-account-xe\"}]}" -n production

##########
# fluentd
##########
helm upgrade --install --wait fluentd stable/fluentd --namespace=production \
  -f lib/fluentd-svcport-exedge.yaml \
  --set output.host=${exops_ip} \
  --set output.port=32500 \
  --set env.EXEDGE_NAME=${exedge_name}


##########
# n2ctxt
##########
helm upgrade --install n3iwf-n2ctxt helm/n3iwf-n2ctxt --namespace production \
 --set env.exedgeName=${exedge_name} \
 --set env.amfIpPort=${excore_ip}:${excore_port} \
 --set env.n3iwfId=${exedge_id} \
 --set env.fluentServer="fluentd.production" \
 --set env.natsServer="nats://nats-client.exopsagent:4222"


##########
# upfN4f3
##########
helm upgrade --install upf-n4fe helm/upf-n4fe --namespace production  --set env.natsServer="nats://nats-client.exopsagent:4222"


##########
# n3iwsess
##########
helm upgrade --install n3iwf-sess helm/n3iwf-sess --namespace production \
 --set env.exedgeName=${exedge_name} \
 --set env.fluentServer="fluentd.production" \
 --set env.natsServer="nats://nats-client.exopsagent:4222"


##########
# upfsess
##########
helm upgrade --install upf-sess helm/upf-sess --namespace production \
 --set env.exedgeName=${exedge_name} \
 --set env.natsServer="nats://nats-client.exopsagent:4222" \
 --set env.fluentServer="fluentd.production" \
 --set env.upfPfcpIpAdrr=""


##########
# n31wfeap5g
##########
helm upgrade --install n3iwf-eap5g helm/n3iwf-eap5g --namespace production \
 --set env.exedgeName=${exedge_name}  \
 --set env.n3iwfName=${exedge_name} \
 --set env.fluentServer="fluentd.production" \
 --set env.natsServer="nats://nats-client.exopsagent:4222"



##########
# upf-fpm
##########
helm upgrade --install --wait --namespace production upf-fpm helm/upf-fpm \
 --set env.exedgeName=${exedge_name}  \
 --set env.n3iwfName=${exedge_name} \
 --set env.n3iwfNwuIpv4Addr="${nwu_ip}" \
 --set env.n3iwfNwuIpv4Mask="${nwu_mask}" \
 --set env.nwuPciAddr="${nwu_pci_addr}" \
 --set env.n3iwfNwuNextIpv4Addr="${nwu_gw_ip}" \
 --set env.upfN6Ipv4AddrMask="${n6_mask}" \
 --set env.n644PciAddr="${n6_pci_addr}" \
 --set env.upfN6NextIpv4Addr="${n6_gw_ip}" \
 --set env.driverPci="vfio-pci" \
 --set env.exedgeId=${exedge_id} \
 --set env.natsServer="nats://nats-client.exopsagent:4222" \
 --set env.upfN6Ipv4Addr="${n6_ip}"

##########
# exe-health
##########
helm upgrade --install --wait --namespace production exe-health helm/exe-health \
 --set env.exedgeName=${exedge_name} \
 --set env.natsServer="nats://nats-client.exopsagent:4222" \
 --set env.xOpsUrl=${xops_url}

##########
# upf-dns
##########
helm upgrade --install --namespace production upf-dns helm/upf-dns

############
# n3iwf-n2fe
############

helm upgrade --install --namespace production n3iwf-n2fe helm/n3iwf-n2fe \
 --set env.fluentServer="fluentd.production" \
 --set env.n2fePort=${n2fe_port} 

# LB patch for Non-cloud setup
##########
nodeCount=$(kubectl get node| wc -l)
if [ $nodeCount -ne 2 ]
then
	echo "Cluster has more than 1 nodes. Setup may not work properly. Please contact Exium" 
        exit 1
else
  nodeExternalIP=$(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}')
  kubectl patch svc ilb-gateway -n istio-system -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
  kubectl patch svc istio-ingressgateway -n istio-system -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
  kubectl patch svc n3iwf-eap5g-udp -n production -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
  kubectl patch svc upf-n4fe-pfcp -n production -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
  kubectl patch svc upf-dns -n production -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${nodeExternalIP}\"]}}"
fi


#########
# configure xcore
#########
# Contact xedge sales team

#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation




set -e

echo "[Pay Attention] MUST run the script on EMCO HOST ..."
echo "[Pay Attention] MUST run the script on EMCO HOST ..."
echo "[Pay Attention] MUST run the script on EMCO HOST ..."
sleep 5
echo "[Pay Attention] MUST run the script after All CLUSTERS Ready ..."
echo "[Pay Attention] MUST run the script after All CLUSTERS Ready ..."
echo "[Pay Attention] MUST run the script after All CLUSTERS Ready ..."
sleep 5


echo "[Input arguments]:"
echo "$@"

if [ -z "$1" ]
  then
    echo "No argument #1 supplied for registry host ip"
    exit 1
fi

if [ -z "$2" ]
  then
    echo "No argument #2 supplied for edge cluster host ip"
    exit
fi

if [ -z "$3" ]
  then
    echo "No argument #2 supplied for cloud cluster host ip"
    exit
fi

log()
{
        green='\033[0;32m'
        reset='\e[0m'
        echo -e "${green}$1${reset}"
}

# EMCO and Harbor on the same Host
REGISTRY_IP=${1}
REGISTRY_HOST=${REGISTRY_IP}:30003/library
EDGE_HOST=${2}
CLOUD_HOST=${3}

# Set EMCO Host IP in valuse.yaml for emcoctl template
YAMLVALUE=values.yaml
sed -i -e "s/RsyncIP:.*/RsyncIP: ${REGISTRY_IP}/g" -e "s/GacIP:.*/GacIP: ${REGISTRY_IP}/g" ${YAMLVALUE}

echo "[starting] building smtc images and push to registry..."
# Yum package install
yum install cmake m4 -y
if [ $? -ne 0 ]; then
        log "yum install cmake ... failed."
        exit 1
fi

# On the OpenNESS EMCO cluster, clone the Smart City Reference Pipeline source code from GitHub and checkout the 577d483635856c1fa3ff0fbc051c6408af725712 commits
git clone https://github.com/OpenVisualCloud/Smart-City-Sample.git
cd Smart-City-Sample
git checkout 577d483635856c1fa3ff0fbc051c6408af725712
if [ $? -ne 0 ]; then
        log "clone smtc ... failed."
        exit 1
fi


# build the SmartCity images
echo "[starting] building the SmartCity images ..."
mkdir build
cmake -DNOFFICES=1 -DREGISTRY=${{REGISTRY_HOST}} 
./deployment/kubernetes/helm/build.sh
make
make tunnels  
if [ $? -ne 0 ]; then
        log "build smtc ... failed."
        exit 1
fi
cd ..


echo "[starting] setting override ..."
# Set cloud host IP in two places !!!!
CLOUDHOST=${CLOUD_HOST}
SMTC=Smart-City-Sample/deployment/kubernetes/helm/smtc
EDGESMTC=../helm-chart/smtc_edge
CLOUDSMTC=../helm-chart/smtc_cloud
VALUESYAML=${SMTC}/values.yaml
sed -i -e "s/    cloudHost:.*/    cloudHost: \"root@${CLOUDHOST}\"/g" -e "s/cloudWebExternalIP:.*/cloudWebExternalIP: \"${CLOUDHOST}\"/g" ${VALUESYAML}

# Set helm-chart api version
CHARTYAML=${SMTC}/Chart.yaml
sed -i "s/apiVersion: v2/apiVersion: v1/g" ${CHARTYAML}

# splite smtc helm chart into edge and cloud at ts29_files/smtc_resource
echo "[starting] spliting smtc helm chart into edge and cloud ..."
mkdir -p ${EDGESMTC}
mkdir -p ${CLOUDSMTC}

# make edge chart
cp -r ${SMTC}/* ${EDGESMTC}
rm -rf ${EDGESMTC}/templates/cloud* 

# make cloud chart
cp -r ${SMTC}/* ${CLOUDSMTC}
rm -rf ${CLOUDSMTC}/templates/* 
cp ${SMTC}/templates/*.tpl ${CLOUDSMTC}/templates/
cp ${SMTC}/templates/cloud* ${CLOUDSMTC}/templates/


echo "[starting] packing helm chart ..."
cd ../helm-chart/
tar -zcvf smtc_edge_helmchart.tar.gz smtc_edge
tar -zcvf smtc_cloud_helmchart.tar.gz smtc_cloud
if [ $? -ne 0 ]; then
        log "package helm chart ... failed."
        exit 1
fi

mv -f smtc_edge_helmchart.tar.gz /opt
mv -f smtc_cloud_helmchart.tar.gz /opt

tar -tvf /opt/smtc_edge_helmchart.tar.gz
tar -tvf /opt/smtc_cloud_helmchart.tar.gz

echo "[starting] packing override ..."
cd ../override-profile/
tar -zcvf smtc_edge_profile.tar.gz -C smtc_edge_profile .
tar -zcvf smtc_cloud_profile.tar.gz -C smtc_cloud_profile .
if [ $? -ne 0 ]; then
        log "package profile ... failed."
        exit 1
fi

tar -tvf smtc_edge_profile.tar.gz
tar -tvf smtc_cloud_profile.tar.gz

mv -f smtc_edge_profile.tar.gz  /opt
mv -f smtc_cloud_profile.tar.gz /opt


echo "[starting] preparing json for configmap ..."
cd ../generic-k8s-resource/
cp sensor-info.json /opt/ 

echo "[starting] creating secret ..."
cd ../cli-scripts/Smart-City-Sample/deployment/tunnel
./create-key.sh root@${{CLOUD_HOST}} ${{REGISTRY_HOST}}

# CLOUD_HOST
scp .key/id_rsa.pub root@${{CLOUD_HOST}}:/root/tunnel_secret
scp .key/id_rsa root@${{CLOUD_HOST}}:/root/tunnel_secret

# EDGE_HOST
scp .key/id_rsa.pub root@${{EDGE_HOST}}:/root/tunnel_secret
scp .key/id_rsa root@${{EDGE_HOST}}:/root/tunnel_secret

# known_hosts
scp .ssh/known_hosts root@${{CLOUD_HOST}}:/root/tunnel_secret
scp .ssh/known_hosts root@${{EDGE_HOST}}:/root/tunnel_secret


echo "[starting] creating certificate ..."
cd ../certificate
./self-sign.sh "${REGISTRY}"

scp self.crt self.key root@${{CLOUD_HOST}}:/root/tunnel_secret

echo "[starting] uploading clusters kubeconfig ..."
mkdir -p /opt/clusters_config/
scp root@${EDGE_HOST}}:/root/.kube/config /opt/clusters_config/edgecluster_config
scp root@${{CLOUD_HOST}}:/root/.kube/config /opt/clusters_config/cloudcluster_config


# on edge and cloud, create k8s secret for ssh
# PRIKEY=/root/tunnel_secret/id_rsa
# PUBKEY=/root/tunnel_secret/id_rsa.pub
# KNOWHOSTS=/root/tunnel_secret/known_hosts
# kubectl create secret generic tunnel-secret --from-file=${PRIKEY} --from-file=${PUBKEY} --from-file=${KNOWHOSTS}

# only on cloud, create k8s secret fo/tunnel_secret/self.crtr certificate
# CRT=/root/tunnel_secret/self.crt
# SELFKEY=/root//tunnel_secret/self.key
# kubectl create secret generic self-signed-certificate --from-file=${CRT}  --from-file=${SELFKEY}

log "Env Setup Successfully."
exit 0

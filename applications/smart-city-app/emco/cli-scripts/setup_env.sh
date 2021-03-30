#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

set -e

pay_attention () {
    echo "[Pay Attention] MUST run the script on EMCO HOST ..."
    echo "[Pay Attention] MUST run the script on EMCO HOST ..."
    echo "[Pay Attention] MUST run the script on EMCO HOST ..."
    sleep 5
    echo "[Pay Attention] MUST run the script after All CLUSTERS Ready ..."
    echo "[Pay Attention] MUST run the script after All CLUSTERS Ready ..."
    echo "[Pay Attention] MUST run the script after All CLUSTERS Ready ..."
    sleep 5
}

# package helm chart
package_helmchart () {
    if ! tar -zcvf smtc_edge_helmchart.tar.gz smtc_edge; then
        log "package edge helm chart ... failed."
        exit 1
    fi

    if ! tar -zcvf smtc_cloud_helmchart.tar.gz smtc_cloud; then
        log "package cloud helm chart ... failed."
        exit 1
    fi
}

# package override
package_override () {
    if ! tar -zcvf smtc_edge_profile.tar.gz -C smtc_edge_profile .; then
        log "package profile ... failed."
        exit 1
    fi

    if ! tar -zcvf smtc_cloud_profile.tar.gz -C smtc_cloud_profile .; then
        log "package profile ... failed."
        exit 1
    fi
}

#create_clusterconfig
create_clusterconfig () {
    if [ -d /opt/openness/clusters_config ]; then
        rm -rf /opt/openness/clusters_config
    fi
    mkdir -p /opt/openness/clusters_config/

    if ! scp "${USER}"@"${EDGE_HOST}":~/.kube/config /opt/openness/clusters_config/edgecluster_config; then
        log "scp /opt/openness/clusters_config/edgecluster_config ... failed."
        exit 1
    fi

    if ! scp "${USER}"@"${CLOUD_HOST}":~/.kube/config /opt/openness/clusters_config/cloudcluster_config; then
        log "scp /opt/clusters_config/cloudcluster_config ... failed."
        exit 1
    fi
}

log() {
    green='\033[0;32m'
    reset='\e[0m'
    echo -e "${green}$1${reset}"
        }

pull_from_docker() {
    pay_attention
    # EMCO and Harbor on the same Host
    REGISTRY_IP=${1}
    REGISTRY_HOST=${REGISTRY_IP}:30003/library
    EDGE_HOST=${2}
    CLOUD_HOST=${3}
    REGISTRY=smartcity/
        
    cur_dir="$(dirname "$(pwd)")"
    docker pull smartcity/smtc_web_cloud_tunnelled:latest
    docker pull smartcity/smtc_certificate:latest
   
    # Adapt to different versions of docker containerd 
    sed -i "15s/\"\$(env/\$(env/g" "$cur_dir"/generic-k8s-resource/shell.sh
    sed -i '15s/)\"/)/g' "$cur_dir"/generic-k8s-resource/shell.sh  
  
    YAMLVALUE=values.yaml
    sed -i -e "s/RsyncIP:.*/RsyncIP: ${REGISTRY_IP}/g" -e "s/GacIP:.*/GacIP: ${REGISTRY_IP}/g" ${YAMLVALUE}
	
    if [ -d /opt/openness/smart_secret ]; then
       rm -rf /opt/openness/smart_secret
    fi	
    mkdir /opt/openness/smart_secret
    cp "$cur_dir"/generic-k8s-resource/create-key.sh "$cur_dir"/generic-k8s-resource/shell.sh "$cur_dir"/generic-k8s-resource/self-sign.sh /opt/openness/smart_secret
    sh /opt/openness/smart_secret/create-key.sh "${USER}@${CLOUD_HOST}"
    sh /opt/openness/smart_secret/self-sign.sh "${REGISTRY}"
	
    sed -i -e "s/    cloudHost:.*/    cloudHost: \"${USER}@${CLOUD_HOST}\"/g" -e "s/cloudWebExternalIP:.*/cloudWebExternalIP: \"${CLOUD_HOST}\"/g" "$cur_dir"/smtc_cloud/values.yaml
    sed -i -e "s/    cloudHost:.*/    cloudHost: \"${USER}@${CLOUD_HOST}\"/g" -e "s/cloudWebExternalIP:.*/cloudWebExternalIP: \"${CLOUD_HOST}\"/g" "$cur_dir"/smtc_edge/values.yaml
	
    #echo "[starting] packing helm chart ..."
    cd "$cur_dir"
    package_helmchart
    mv -f smtc_edge_helmchart.tar.gz smtc_cloud_helmchart.tar.gz /opt/openness

    echo "[starting] packing override ..."
    cd "$cur_dir"/override-profile
    package_override
    mv -f smtc_edge_profile.tar.gz smtc_cloud_profile.tar.gz /opt/openness
	
    cd "$cur_dir"/cli-scripts
    echo "[starting] uploading clusters kubeconfig ..."
    create_clusterconfig

    echo "[starting] preparing json for configmap ..."
    cp "$cur_dir"/generic-k8s-resource/sensor-info.json /opt/openness
    
    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/.ssh
    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/.key
    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/self.key
    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/self.crt

    echo "[starting] prepare edge cluster environment ..."
    # clean up network policy on cloud and edge
    kubectl --kubeconfig=/opt/openness/clusters_config/edgecluster_config delete netpol block-all-ingress >/dev/null 2>&1
    kubectl --kubeconfig=/opt/openness/clusters_config/cloudcluster_config delete netpol block-all-ingress >/dev/null 2>&1

    log "Env Setup Successfully."
    exit 0
	
}

pull_from_harbor() {
    pay_attention
    # EMCO and Harbor on the same Host
    REGISTRY_IP=${1}
    REGISTRY_HOST=${REGISTRY_IP}:30003/library/
    EDGE_HOST=${2}
    CLOUD_HOST=${3}
	
    # Set EMCO Host IP in values.yaml for emcoctl template
    YAMLVALUE=values.yaml
    sed -i -e "s/RsyncIP:.*/RsyncIP: ${REGISTRY_IP}/g" -e "s/GacIP:.*/GacIP: ${REGISTRY_IP}/g" ${YAMLVALUE}

    echo "[starting] building smtc images and push to registry..."
    # Yum package install
    if ! sudo yum install cmake m4 -y; then
        log "yum install cmake ... failed."
        exit 1
    fi
	
    cur_dir="$(dirname "$(pwd)")"

    # On the OpenNESS EMCO cluster, clone the Smart City Reference Pipeline source code from GitHub and checkout the 577d483635856c1fa3ff0fbc051c6408af725712 commits
    if [ -d Smart-City-Sample ]; then
        mv -f Smart-City-Sample Smart-City-Sample.bak
    fi
    git clone https://github.com/OpenVisualCloud/Smart-City-Sample.git
    cd Smart-City-Sample
    if ! git checkout 577d483635856c1fa3ff0fbc051c6408af725712; then
        log "clone smtc ... failed."
        exit 1
    fi

    # build the SmartCity images
    echo "[starting] building the SmartCity images ..."
    if [ ! -d build ]; then
        mkdir build
    fi

    cmake -DNOFFICES=1 -DREGISTRY="${REGISTRY_HOST}"
    ./deployment/kubernetes/helm/build.sh

    #Modify the judgment conditions and parameters in SmartCity
    sed -i '9s/gt/eq/' "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/templates/office-db.yaml
    sed -i '223s/eq/gt/' "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/templates/office-db.yaml
    sed -i '16s/gt/eq/' "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/templates/_helpers.tpl
    sed -i '27s/gt/eq/' "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/templates/_helpers.tpl
    sed -i "20s/{{ \$nanalytics }}/1/" "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/templates/analytics.yaml
    sed -i '55s/gt/eq/' "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/templates/cloud-db.yaml

    #Determine whether there is already SmartCity images in harbor
    H_token=$(curl -k -i -u admin:Harbor12345 https://"${REGISTRY_IP}":30003/service/token\?account=admin\&service=harbor-registry\&scope=registry:catalog:\*|grep "token" |awk -F '"' '{print $4}')
    touch images.txt
    #echo "$(curl -X GET -k -s "authorization: bearer $H_token" "https://${REGISTRY_IP}:30003/api/v2.0/projects/library/repositories?page=1&page_size=16" -H "accept: application/json"|jq|grep "name")"|sed 's/,/\n/g' > images.txt
    (curl -X GET -k -s "authorization: bearer $H_token" "https://${REGISTRY_IP}:30003/api/v2.0/projects/library/repositories?page=1&page_size=16" -H "accept: application/json"|jq|grep "name")|sed 's/,/\n/g' > images.txt
    touch images_list.txt
    less images.txt | awk -F "[:]" '/name/{print$2}'|sed 's/\"//g'|grep '^ library/smtc.*'|sort >images_list.txt
    rm -rf images.txt
    images_n=$(cat < images_list.txt |wc -l)
    if [ "$images_n" -lt 16 ]; then
        sudo make
        sudo make tunnels
        cd ..
    else
        #sed -i '0,/^\(registryPrefix: *\).*/s//\1"${REGISTRY_HOST}"/' $cur_dir/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/values.yaml
    	sed -i '4 d' "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/values.yaml
    	echo registryPrefix: "\"${REGISTRY_HOST}\"" >> "$cur_dir"/cli-scripts/Smart-City-Sample/deployment/kubernetes/helm/smtc/values.yaml
    	cd ..
    fi

    echo "[starting] setting override ..."
    # Set cloud host IP in two places !!!!
    CLOUDHOST=${CLOUD_HOST}
    SMTC=Smart-City-Sample/deployment/kubernetes/helm/smtc
    EDGESMTC=../helm-chart/smtc_edge
    CLOUDSMTC=../helm-chart/smtc_cloud
    VALUESYAML=${SMTC}/values.yaml
    sed -i -e "s/    cloudHost:.*/    cloudHost: \"${USER}@${CLOUDHOST}\"/g" -e "s/cloudWebExternalIP:.*/cloudWebExternalIP: \"${CLOUDHOST}\"/g" ${VALUESYAML}

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
    package_helmchart
    mv -f smtc_edge_helmchart.tar.gz smtc_cloud_helmchart.tar.gz /opt/openness

    echo "[starting] packing override ..."
    cd ../override-profile/
    package_override
    mv -f smtc_edge_profile.tar.gz smtc_cloud_profile.tar.gz /opt/openness
 	
    echo "[starting] preparing json for configmap ..."
    cd ../generic-k8s-resource/
    cp sensor-info.json /opt/openness

    echo "[starting] uploading clusters kubeconfig ..."
    create_clusterconfig

    echo "[starting] creating secret ..."
    cd ../cli-scripts/Smart-City-Sample/deployment/tunnel
    if ! ./create-key.sh "${USER}@${CLOUD_HOST}"; then
        log "creating secret ... failed."
        exit 1
    fi
    if [ -d /opt/openness/smart_secret ]; then
        rm -rf /opt/openness/smart_secret
    fi
    mkdir /opt/openness/smart_secret
    sudo mv -f .key .ssh /opt/openness/smart_secret

    echo "[starting] creating certificate ..."
    cd ../certificate
    if ! ./self-sign.sh "${REGISTRY}"; then
        log "create certificate ... failed."
        exit 1
    fi
    sudo mv -f self.crt self.key /opt/openness/smart_secret

    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/.ssh
    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/.key
    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/self.key
    sudo chown -R "${USER}":"${USER}" /opt/openness/smart_secret/self.crt

    echo "[starting] prepare edge cluster environment ..."
    # clean up network policy on cloud and edge
    kubectl --kubeconfig=/opt/openness/clusters_config/edgecluster_config delete netpol block-all-ingress cdi-upload-proxy-policy >/dev/null 2>&1
    kubectl --kubeconfig=/opt/openness/clusters_config/cloudcluster_config delete netpol block-all-ingress cdi-upload-proxy-policy >/dev/null 2>&1

    log "Env Setup Successfully."
    exit 0
        
}

func() {
    echo "Usage:"
    echo "emcosetup_env.sh [-e EMCO_IP] [-d EDGE_IP] [-c CLOUD_IP] [-r] or [-n]"
    echo "Description:"
    echo "EMCO_IP: emco cluster ip."
    echo "EDGE_IP: edge cluster ip."
    echo "EDGE_IP: cloud cluster ip."
    echo "-r: rebuild SmartCity images from SmartCity source code(It will take about two hours)"
    exit -1
}
while getopts 'e:c:d:rnh' OPT; do
    case $OPT in
        e) emco_ip="$OPTARG";;
        d) edge_ip="$OPTARG";;
        c) cloud_ip="$OPTARG";;
        r) pull_from_harbor "$emco_ip" "$edge_ip" "$cloud_ip";;
        h) func;;
    esac
done

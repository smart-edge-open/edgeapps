#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2022 Intel Corporation

CTK_CHART_DIR="$PWD/chart/"
APPHSM_HOST=$1
SSH_USER=${2:-ubuntu}
SSH_PEM_KEY=$3
CTK_UID="ctk_loadkey_user_id_01234"
CTK_APP="ctk_loadkey"
CTK_NAMESPACE="kmra"

TARGET_CERTS_PATH="/opt/smartedge/kmra/mtls"

copy_mtls_ca_certs() {
    sudo mkdir -p $TARGET_CERTS_PATH
    sudo chown -R "$USER":"$USER" $TARGET_CERTS_PATH
    echo "***************** copying tls CA cert from apphsm ********************* "
    scp -o StrictHostKeyChecking=no -r -i "$SSH_PEM_KEY" "$SSH_USER"@"$APPHSM_HOST":$TARGET_CERTS_PATH/ca.* $TARGET_CERTS_PATH || { echo "Failed to copy CA certificate from apphsm"; exit; }
    echo "*********** copying tls CA cert from apphsm DONE.......... **********"
    return 0
}

generate_ctk_loadkey_certs() {
    cd $TARGET_CERTS_PATH || { echo "directory $TARGET_CERTS_PATH not found"; exit; }
    echo "Generate key and csr for CTK loadkey.."
    # Generate key and CSR for CTK loadkey
    openssl req -nodes -newkey rsa:2048 -keyout $CTK_APP.key -out $CTK_APP.csr -subj "/O=AppHSM/OU=$CTK_UID"

    echo "Generate CTK loadkey cert..."
    # Generate Certificate for CTK loadkey using CA certficate
    openssl x509 -req -in $CTK_APP.csr -CA ca.crt -CAkey ca.key -CAserial ca.srl -out $CTK_APP.crt
    return 0
}

create_ctk_k8s_secret() {
    cd $TARGET_CERTS_PATH || { echo "directory $TARGET_CERTS_PATH not found"; exit; }
    kubectl create secret generic ctk-tls --from-file=tls.cert=$CTK_APP.crt --from-file=tls.key=$CTK_APP.key --from-file=ca.cert=ca.crt -n $CTK_NAMESPACE -o yaml --dry-run=client | kubectl apply -f -
}

delete_tls_certs() {
    sudo rm -r $TARGET_CERTS_PATH || { echo "Failed to delete $TARGET_CERTS_PATH"; exit; }
}

deploy_ctk_chart() {
    cd "$CTK_CHART_DIR" || { echo "directory $CTK_CHART_DIR not found"; exit; }
    helm install ctk ./kmra-ctk -n $CTK_NAMESPACE
}

# Copy CA certs from setup where appHSM is deployed
copy_mtls_ca_certs || { echo "Failed to copy CA certificate from appHSM node, exiting.."; exit 1; }

generate_ctk_loadkey_certs || { echo "Failed to generate certificate and RSA key for CTK, exiting.."; exit 1; }

# create namespace for ctk to deploy CTK secrets and pods
kubectl create namespace $CTK_NAMESPACE

create_ctk_k8s_secret || { echo "Failed to create tls secrets for CTK"; exit 1; }

delete_tls_certs || { echo "Failed to delete tls certificates"; exit 1; }

deploy_ctk_chart || { echo "Failed to deploy CTK helm chart, exiting.."; exit 1; }

echo "CTK chart has been deployed successfully!!"

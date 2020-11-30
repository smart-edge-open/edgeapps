#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup a tunnel between edge1 and hub

sdewan_cnf_name=sdewan-cnf
hubIp=$HUB_CNF_NET3_IFIP
HUB_OIP=$O_TUNNEL1_HUB_IP
LOCAL_IDENTIFIER=$EDGE1_P2
TUNNEL_NAME=sdewan-edge1-2-hub

echo "--------------------- Applying CRDs ---------------------"
cat > ipsec_proposal.yaml << EOF
---
apiVersion: batch.sdewan.akraino.org/v1alpha1
kind: IpsecProposal
metadata:
  name: ipsecproposal
  namespace: default
  labels:
    sdewanPurpose: $sdewan_cnf_name
spec:
  dh_group: modp3072
  encryption_algorithm: aes128
  hash_algorithm: sha256
EOF

kubectl apply -f ipsec_proposal.yaml

cat > ipsec_config.yaml << EOF
---
apiVersion: batch.sdewan.akraino.org/v1alpha1
kind: IpsecHost
metadata:
  name: ipsechost
  namespace: default
  labels:
    sdewanPurpose: $sdewan_cnf_name
spec:
    name: $TUNNEL_NAME
    remote: $hubIp
    pre_shared_key: test_key
    authentication_method: psk
    local_identifier: $LOCAL_IDENTIFIER
    crypto_proposal:
      - ipsecproposal
    force_crypto_proposal: "0"
    connections:
    - name: connA
      conn_type: tunnel
      mode: start
      local_sourceip: "%config"
      remote_subnet: $HUB_OIP/24,$hubIp/32
      crypto_proposal:
        - ipsecproposal
EOF

kubectl apply -f ipsec_config.yaml

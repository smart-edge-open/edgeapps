#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup tunnel site, multi tunnel host can connet to one tunnel site

# one tunnel between edge1 and hub
sdewan_cnf_name=sdewan-cnf
hubIp="$HUB_CNF_NET3_IFIP/32,$HUB_CNF_NET4_IFIP/32"
HUB_OIP=$O_TUNNEL1_NET
TUNNEL_NAME=sdewan-hub

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
kind: IpsecSite
metadata:
  name: ipsecsite
  namespace: ${NS:-default}
  labels:
    sdewanPurpose: $sdewan_cnf_name
spec:
    name: $TUNNEL_NAME
    remote: "%any"
    pre_shared_key: test_key
    authentication_method: psk
    local_identifier: ""
    crypto_proposal:
      - ipsecproposal
    force_crypto_proposal: "0"
    connections:
    - name: connA
      conn_type: tunnel
      mode: start
      remote_sourceip: $HUB_OIP
      local_subnet: $HUB_OIP,$hubIp
      crypto_proposal:
        - ipsecproposal
EOF

kubectl apply -f ipsec_config.yaml

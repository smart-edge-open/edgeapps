#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

# setup 2 tunnels

# one tunnel between edge1 and hub
sdewan_cnf_name=sdewan-cnf
hubIp=$HUB_CNF_NET3_IFIP
REMOTE_IP=$O_TUNNEL1_EDGE1_IP
HUB_OIP=$O_TUNNEL1_HUB_IP
TUNNEL_NAME=sdewan-hub-2-edge1

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
  namespace: default
  labels:
    sdewanPurpose: $sdewan_cnf_name
spec:
    name: $TUNNEL_NAME
    remote: "%any"
    pre_shared_key: test_key
    authentication_method: psk
    local_identifier: $hubIp
    crypto_proposal:
      - ipsecproposal
    force_crypto_proposal: "0"
    connections:
    - name: connA
      conn_type: tunnel
      mode: start
      remote_sourceip: "$REMOTE_IP"
      local_subnet: $HUB_OIP/24,$hubIp/32
      crypto_proposal:
        - ipsecproposal
EOF

kubectl apply -f ipsec_config.yaml


# another tunnel between edge2 and hub
sdewan_cnf_name=sdewan-cnf
hubIp=$HUB_CNF_NET4_IFIP
REMOTE_IP=$O_TUNNEL1_EDGE2_IP
HUB_OIP=$O_TUNNEL1_HUB_IP
TUNNEL_NAME=sdewan-hub-2-edge2

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
  namespace: default
  labels:
    sdewanPurpose: $sdewan_cnf_name
spec:
    name: $TUNNEL_NAME
    remote: "%any"
    pre_shared_key: test_key
    authentication_method: psk
    local_identifier: $hubIp
    crypto_proposal:
      - ipsecproposal
    force_crypto_proposal: "0"
    connections:
    - name: connA
      conn_type: tunnel
      mode: start
      remote_sourceip: "$REMOTE_IP"
      local_subnet: $HUB_OIP/24,$hubIp/32
      crypto_proposal:
        - ipsecproposal
EOF

kubectl apply -f ipsec_config.yaml

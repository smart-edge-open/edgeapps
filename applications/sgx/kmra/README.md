```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Intel Corporation
```

# Key Management Reference Application (KMRA) using Intel® SGX

## CONTENTS

- [Introduction](#INTRODUCTION)
- [Preconditions](#PRECONDITIONS)
- [CTKDeployment](#CTK_LOADKEY_DEPLOYMENT)
- [KeyConfiguration](#CTK_KEY_CONFIGURATION_PARAMETERS)

## INTRODUCTION

KMRA (Key Management Reference Application) is a proof-of-concept software focused on Key Management provisioning using Intel® SGX technology. This reference application sets up a NGINX workload to access the private key in an Intel® SGX enclave on a 3rd Generation Intel® Xeon® Scalable processor, using the Public-Key Cryptography Standard (PKCS) #11 interface and OpenSSL. Refer [KMRA docmumentaion](https://www.intel.com/content/www/us/en/developer/topic-technology/open/key-management-reference-application/overview.html) for more details.
KMRA provides Helm charts to deploy KMRA components in kubernetes environment.

## PRECONDITIONS

* Edge node should be provisioned with [DEK](https://smart-edge-open.github.io/docs/experience-kits/developer-experience-kit/#get-started) and SGX enabled
* Apphsm(Key server) should be actively running on AWS cloud instance.
* If deploying ctk pods behind proxy network, update no_proxy, http_proxy and https_proxy
  in applications/sgx/kmra/ctk/chart/kmra-ctk/values.yaml with correct proxy settings.
* Update pccs port, pccs ip, apphsm port and apphsm host ip in applications/sgx/kmra/ctk/chart/kmra-ctk/values.yaml.
  Optionally, client key configurations can be modified if using default values is not desired.
* Check sgx_prv group id on DEK host by using following command. If GID is not equal to 1002, then modify sgx_prv_gid in
  applications/sgx/kmra/ctk/chart/kmra-ctk/values.yaml
  ```text
  $ cat /etc/group | grep sgx_prv
  ```

## CTK_LOADKEY_DEPLOYMENT

Run Ctk_loadkey pod:

* Run applications/sgx/kmra/ctk/deploy_ctk.sh script by passing APPHSM_HOST, SSH_USER, SSH_PEM_KEY as command line argument.

  ```text
  $ cd <EDGEAPP_HOME>/applications/sgx/kmra/ctk/
  $ ./deploy_ctk.sh <apphsm_host_ip> <apphsm_ssh_user> <apphsm_ssh_pem_key>
  ```

  This will copy CA certificate generated at Apphsm, generates mTLS certificates and keys for ctk_loadkey. Then, it generates kubernetes TLS secret and deploys ctk helm charts.
* On successfull deployment, following status can be observed.

  ```text
  $ kubectl get pods -n kmra
  NAME READY STATUS RESTARTS AGE
  ctk-75965454cf-twwl9 1/1 Running 1269 (23h ago) 11d
  ```

  ```text
  $ kubectl logs -n kmra ctk-75965454cf-twwl9
  Create empty token in hsm
  Slot 0 has a free/uninitialized token.
  The token has been initialized and is reassigned to slot 119347065
  Provision ctk with key from apphsm
  rest_api_check_version: Supports AppHSM v0.1 (or newer) API v0.1.
  rest_api_check_version: Connected to AppHSM v0.1 API v0.1.
  Check if key exists in token
  Generate certificate for nginx
  engine "pkcs11" set.
  Start nginx
  ```

## CTK_KEY_CONFIGURATION_PARAMETERS

* **client_token**: Private key for the certificate for NGINX which will be stored in client token label. Default value is **client_token**
* **client_key_label**: Label of the key which NGINX will use to find key.
  Default value is **client_key_priv**
* **test_unique_uid**: Unique id of the key located on AppHSM. Client can obtain its key by
  requesting this unique id. Default value is **unique_id_1234**
* **default_user_pin**: Crypto-Api-Toolkit user pin. Valid length is 4-16 chars.
  Default value is **1234**
* **default_so_pin**: Crypto-Api-Toolkit security officer pin. Valid length is 4-16 chars. Please consult your security officer. Default value is **12345678**

**NOTE**: If custom key values are configured, same parameters need to be used while executing RSA Encryption/Decryption use case.

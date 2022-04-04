===============================================================================
README for deploying KMRA ctk container

April 2022
===============================================================================

CONTENTS
========

- Introduction
- Disclaimer
- Preconditions
- Container deployment via Dockerfiles

INTRODUCTION
============

KMRA provides Dockerfiles to deploy KMRA containers

DISCLAIMER
==========

CIS Docker Benchmark tool returned warnings in the following sections:
[WARN] 4.6 - Ensure HEALTHCHECK instructions have been added to the container image
[WARN] 5.2 - Ensure SELinux security options are set, if applicable
[WARN] 5.10 - Ensure memory usage for container is limited
[WARN] 5.11 - Ensure CPU priority is set appropriately on the container
[WARN] 5.12 - Ensure the container's root filesystem is mounted as read only
[WARN] 5.14 - Ensure 'on-failure' container restart policy is set to '5'
[WARN] 5.25 - Ensure the container is restricted from acquiring additional privileges
[WARN] 5.26 - Ensure container health is checked at runtime
[WARN] 5.28 - Ensure PIDs cgroup limit is used

Sample scan command for detailed list of warnings:
$ docker run -it --net host --pid host --userns host --cap-add audit_control \
-e DOCKER_CONTENT_TRUST=$DOCKER_CONTENT_TRUST \
-v /var/lib:/var/lib \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/lib/systemd:/usr/lib/systemd \
-v /etc:/etc --label docker_bench_security \
docker/docker-bench-security docker-bench-security.sh -x registry > docker_security_scan_result.txt

Reduce warnings to run the containers in a more secure manner.

PRECONDITIONS
=============

1) Install SGX kernel driver. Out-of-tree SGX kernel driver can be installed
    using KMRA ansible scripts in ansible/sgx-infra-setup directory.

2) If deploying containers behind a proxy, update no_proxy, http_proxy and
   https_proxy in Dockerfile.apphsm and Dockerfile.ctk with correct proxy
   settings. Also, update no_proxy variable in *.sh files.
3) Generate Apphsm mTLS certificates and keys to share with ctk containers
4) Get an ApiKey for the Provisioning Certification Service

CTK_LOADKEY CONTAINER DEPLOYMENT VIA DOCKERFILES
==================================================

Run Ctk_loadkey container:

1) Update the values.yaml
2) To Install:
   `helm install ctk kmra-ctk -n ctk`
3) To Uninstall:
   `helm uninstall ctk -n ctk`

Build arguments:
- DCAP_VERSION - 1.12.1 by default
- DCAP_LIB_VERSION - 1.12.101.1 by default
- SGX_VERSION - 2.15.1 by default
- SGX_LIB_VERSION - 2.15.101.1 by default
- USER - a name of the user inside the container (kmra by default)
- UID - UID for the above user (1000 by default)

Environment variables:
- APPHSM_HOSTNAME - host on which AppHSM service is listening (localhost by default)
  Usually it should be set to a name of the AppHSM container - "apphsm" (the last argument
  in docker run ... command starting AppHSM container)
- APPHSM_PORT - port on which AppHSM service is listening (5000 by default)
- NGINX_HOSTNAME - the host name on which nginx will listen (0.0.0.0 by default)
- NGINX_PORT - port on which nginx will listen (8082 by default)
- no_proxy - a list of host names, IP addresses, IP subnets for that the proxy will not be used
- CLIENT_TOKEN - private key for the certificate for nginx will be stored by ctk_loadkey
  in this token label (client_token by default)
- CLIENT_KEY_LABEL - label of the key which nginx will use to finds its key
  (client_key_priv by default)
- TEST_UNIQUE_UID - unique id of the key definition located on AppHSM side in apphsm.conf.
  Client can obtain this key by requesting this unique id using ctk_loadkey
- TEST_UNIQUE_UID - unique id of the key definition located on AppHSM side in apphsm.conf.
  Client can obtain this key by requesting this unique id using ctk_loadkey
- DEFAULT_USER_PIN - Crypto-Api-Toolkit user pin. Valid length is 4-16 chars. (1234 is default)
- DEFAULT_SO_PIN - Crypto-Api-Toolkit security officer pin. Valid length is 4-16 chars. Please
  consult your security officer. (12345678 is default)

PCCS configuration file containers/ctk/sgx_default_qcnl.conf:
- PCCS_URL - valid url address of pccs service (https://pccs:8081/sgx/certification/v3/ by default)
- USE_SECURE_CERT - to accept insecure HTTPS cert for PCCS URL, set this option
  to FALSE (FALSE by default)

COMMON PROBLEMS
===============

1. Failure in task '[create_empty_token_in_hsm: Create token ...]'
Error log:
TASK [create_empty_token_in_hsm : Create token with name 'client_token'] *******
fatal: [localhost]: FAILED! => {"changed": true, "cmd": ["softhsm2-util", "--module", "/usr/local/lib/libp11sgx.so.0.0.0", "--init-token", "--free", "--label", "client_token", "--pin", "1234", "--so-pin", "12345
678"],
...
Could not initialize the PKCS#11 library/module: /usr/local/lib/libp11sgx.so.0.0.0\nERROR: Please check log files for additional information.", "stderr_lines": ["[get_driver_type /home/sgx/jenkins/ubuntuServer2004-release-build-tr
unk-213.3/build_target/PROD/label/Builder-UbuntuSrv20/label_exp/ubuntu64/linux-trunk-opensource/psw/urts/linux/edmm_utility.cpp:111] Failed to open Intel SGX device.", "ERROR: Could not initialize the PKCS#11 li
brary/module: /usr/local/lib/libp11sgx.so.0.0.0", "ERROR: Please check log files for additional information."], "stdout": "", "stdout_lines": []}

Root cause:
There is a problem with sharing SGX services (e.g. lack of --device /dev/sgx/enclave passed to the container during runtime)

2. Failure in task [install_ctk_loadkey: Copy ca cert and ctk_loadkey keys ...]
Error log:
TASK [install_ctk_loadkey : Copy ca cert and ctk_loadkey keys to /opt/intel/ctk_loadkey] ***
changed: [localhost] => (item=ctk_loadkey.crt)
fatal: [localhost]: FAILED! => {"msg": "an error occurred while trying to read the file '/opt/intel/ca/ctk_loadkey.key': [Errno 13] Permission denied: b'/opt/intel/ca/ctk_loadkey.key'. [Errno 13] Permission denied: b'/opt/intel/ca/ctk_loadkey.key'"}

Root cause:
There is mismatch between user id in the container and the user that owns shared
certificate/key files. Make sure that certificate/key files for ctk_loadkey are
accessible for 'kmra' user inside container.

3. Enclave not authorized to run in task  [provision_ctk_with_key_from_apphsm ...]
Error log:
TASK [provision_ctk_with_key_from_apphsm : Provision token client_token with key client_key_priv from AppHSM] ***
fatal: [localhost]: FAILED! => {"changed": true, "cmd": "cd /opt/intel/ctk_loadkey; https_proxy=\"\" ./ctk_loadkey -t client_token -p 1234 -u unique_id_1234 -P 5000 -H silpixa00400537", "delta": "0:00:00.478512", "end": "2021-07-19 13:33:45.166066", "msg": "non-zero return code", "rc": 5, "start": "2021-07-19 13:33:44.687554", "stderr": "[error_driver2api sgx_enclave_common.cpp:247] Enclave not authorized to run, .e.g. provisioning enclave hosted in app without access rights to /dev/sgx_provision. You need add the user id to group sgx_prv or run the app as root.\n[load_pce ../pce_wrapper.cpp:175] Error, call sgx_create_enclave for PCE fail [load_pce], SGXError:4004.", "stderr_lines": ["[error_driver2api sgx_enclave_common.cpp:247] Enclave not authorized to run, .e.g. provisioning enclave hosted in app without access rights to /dev/sgx_provision. You need add the user id to group sgx_prv or run the app as root.", "[load_pce ../pce_wrapper.cpp:175] Error, call sgx_create_enclave for PCE fail [load_pce], SGXError:4004."], "stdout": "Error during C_WrapKey-size: CKR_GENERAL_ERROR\nError during creating ecdsa_quote: CKR_GENERAL_ERROR\nError during ctk_quote generation", "stdout_lines": ["Error during C_WrapKey-size: CKR_GENERAL_ERROR", "Error during creating ecdsa_quote: CKR_GENERAL_ERROR", "Error during ctk_quote generation"]}

Root cause:
There is a mismatch between group id for 'sgx_prv' group in the container and the
same group on the host. Make sure that both group ids are equal.

4. SSL peer certificate error in task [provision_ctk_with_key_from_apphsm..]
Error log:
fatal: [localhost]: FAILED! => {"changed": true, "cmd": "cd /opt/intel/ctk_loadkey; https_proxy=\"\" ./ctk_loadkey -t client_token -p 1234 -u unique_id_1234 -P 5000 -H apphsm", "delta": "0:00:01.702477", "end": "2021-07-20 12:15:58.111058", "msg": "non-zero return code", "rc": 5, "start": "2021-07-20 12:15:56.408581", "stderr": "", "stderr_lines": [], "stdout": "rest_api_check_version: Supports AppHSM v0.1 (or newer) API v0.1.\nrest_api_perform_request: REST API request failed 'SSL peer certificate or SSH remote key was not OK'!\nrest_api_check_version: Failed to get AppHSM version!\nFAILED REST API initialization for host 'apphsm' on port 5000: -93\nFailed to send export key request: CKR_GENERAL_ERROR", "stdout_lines": ["rest_api_check_version: Supports AppHSM v0.1 (or newer) API v0.1.", "rest_api_perform_request: REST API request failed 'SSL peer certificate or SSH remote key was not OK'!", "rest_api_check_version: Failed to get AppHSM version!", "FAILED REST API initialization for host 'apphsm' on port 5000: -93", "Failed to send export key request: CKR_GENERAL_ERROR"]}

Root cause:
AppHSM common name in the AppHSM certificate does not match domain name used for
connecting to AppHSM from ctk_loadkey container (e.g. in the error above,
certificate was generated for 'localhost' but it should be generated for 'apphsm'
instead). Generate certificates again with proper APPHSM_HOSTNAME variable set and
restart apphsm and ctk_loadkey containers.

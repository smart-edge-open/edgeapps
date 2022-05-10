```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2022 Intel Corporation
```

# RSA Encryption/Decryption use case with KMRA

This use case demonstrates encryption(client) and decryption(server) using the **PRIVATE KEY** provisioned into Crypto toolkit enclave.

Follow below procedure after successful deployment of CTK along with NGINX on DEK provisioned edge node.

### Step 1:

On **client** node(any physical host/VM or edge node itself), encrypt sample text using public key certificate on CTK pod using below steps.

* Copy NGINX public key certificate from CTK pod to host.
  ```text
    kubectl cp kmra/<ctk-pod>:/tmp/nginx_cert.pem <host_path>
  ```
* Copy certificate to client host(local/remote)
  ```text
    cp <host_path>/nginx_cert.pem <client_host_path>
  ```
* Extract public key from the certificate.
  ```text
    openssl x509 -pubkey -noout -in <client_host_path>/nginx_cert.pem  > pubkey.pem
  ```
* Create a text file with sample data to be encrypted
  ```text
    echo "Credit card pin: 4321" > secrets.txt
  ```
* Encrypt the data using the extracted public key
  ```text
    openssl rsautl -encrypt -inkey pubkey.pem -in secrets.txt -pubin -out secrets.enc
  ```

### Step 2:

On **edge node**(DEK node provisioned with SGX), decrypt cipher text file using private key provisioned into CTK enclave

* Copy cipher text generated in the end of Step 1 to CTK pod. Copy cipher text file to edge node if client host is remote.
  ```text
    kubectl cp <cipher_txt_path>/secrets.enc kmra/<ctk-pod>:/tmp/
  ```
* Decrypt cipher text using private key stored in the token inside enclave.
  Default values are passed to parameters like key_label, user_pin. If non-default values are configured in values.yml
  while deploying CTK then same values must be passed here.
  ```text
  kubectl exec -it -n kmra <ctk-pod> -- pkcs11-tool --decrypt -i /tmp/secrets.enc --label client_key_priv -p 1234 -m RSA-PKCS --module /usr/local/lib/libp11sgx.so.0.0.0
  ```
* Once decryption is success, observe the original text in plain
  ```text
    Using slot 0 with a present token (0x37276fc7)
    Using decrypt algorithm RSA-PKCS
    Credit card pin: 4321
  ```


## Running applications in SGX enclave

### Prerequisites

Before you proceed, ensure that you check the following requirements are met on you system.

1.) Docker proxy - Ensure you have proxy configured for docker if you are on a corporate network with proxy. Follow the instructions [here](https://docs.docker.com/network/proxy/) to configure proxy settings for docker.

2.) Intel SGX enablement - If you plan to use docker, ensure you have /dev/sgx_enclave and /dev/sgx_provision available on your system. If you choose kubernetes, check if the Intel Device Plugin has exposed the Intel SGX resources to node using the command - ``kubectl describe node <NODE_NAME>``. An output as below is expected in the ``Allocatable`` section -

```
  sgx.intel.com/enclave:    110
  sgx.intel.com/epc:        136625258496
  sgx.intel.com/provision:  110
```

3.) PRMRR size - You need to ensure that your system has 64G configured as the value of PRMRR (Processor Reserved Memory Range Registers) Size in SGX configuration section of the BIOS.

### Build you base docker image
Build the base openvino sample tool.

``docker-compose build``

This should create an image by the name ``openvino-ssd`` (which can be replaced by the name of your application).

Clone and move into the gsc project directory.
```
git clone https://github.com/gramineproject/gsc.git
cd ./gsc
```

### Install dependencies for Gramine Shielded Container
```
sudo apt-get install docker.io python3 python3-pip
pip3 install docker jinja2 toml pyyaml
```

Create a config file ``config.yaml`` from the sample template file ``config.yaml.template``.

``cp config.yaml.template config.yaml``

### Build the graminized docker image

You might want to update the config file if you want to run the sample multiple times. For this, you will have to build the Gramine base image and retain it for further use. This will save the build time for Gramine base image every time you make a change to the sample (or your application you want to run with SGX). If you want the base image to be 20.04, update the first line in this file as well to look like - ``Distro: "ubuntu:20.04"``.

Now to build the reusable base gramine image, run the following command -

``./gsc build-gramine gramine-base``

Note the last argument here ``gramine-base``. This has to be mentioned in the ``config.yaml`` as the value for property ``Gramine.Image``. Once this is done, Gramine will not be built every time you make modifications to your application and graminize it. You can replace this name with one of your choice ensuring the same is used in the config file.

Now, the graminized image of the application can be built. If you choose to run the default openvino-ssd example, follow method 1 below or you can go ahead with method 2 for a custom application.

#### Method 1
 
You need to set the ``PROJECT_HOME`` environment variable -

``export PROJECT_HOME=~/edgeapps/applications/sgx/openvino-ssd``

Copy the script file ``build_gsc_openvino_ssd.sh`` from the sample application.

``cp $PROJECT_HOME/gramine/build_gsc_openvino_ssd.sh ./``

Run the script to generate the graminized docker image which is capable of running the sample (or your application) inside a SGX secure enclave.

``./build_gsc_openvino_ssd.sh``

You should see an image ``gsc-openvino-ssd`` on your system after this stage. Use the command ``docker image ls``to verify this.

#### Method 2

You need to run through the folowing steps to graminize you custom application -

1.) Generate the signing key if you already do not have one using openssl
``openssl genrsa -3 -out enclave-key.pem 3072``

2.) Build unsigned graminized image
``./gsc build <IMAGE_NAME> <MANIFEST_FILE>``
For creating a manifest file, refer the documentation [here](https://gramine.readthedocs.io/en/latest/manifest-syntax.html).

3.) Sign the image to get the final graminized image 
``./gsc sign-image <IMAGE_NAME> enclave-key.pem``

At the end of these steps you should see an image on you system with ``gsc-`` prefixed to the original image name. Use the command ``docker image ls``to verify this. 

The image name prefixed with ``gsc-`` is the graminized images in both the methods. This needs to be specified in the kubernetes job manifest or docker-compose file. Note that you will also see another image with the suffix ``-unsigned``, which is an intermediate image only.

### Run the sample in SGX
Now you can jump back to the sample directory and run the sample with SGX using docker-compose or you could run a kubernetes job and check the logs to see the input image having been processed.

If you want to run the object detection on another image, you need to update the command field in the job manifest file ``job.yaml`` with another image that is present in ``images`` directory.

```
kubectl apply -f job.yaml

kubectl logs -f ``<POD_NAME>``
```

You should see an out similar to -

```
++ find /gramine/meson_build_output/lib -type d -path '*/site-packages'
+ export PYTHONPATH=:/gramine/meson_build_output/lib/python3.6/site-packages
+ PYTHONPATH=:/gramine/meson_build_output/lib/python3.6/site-packages
++ find /gramine/meson_build_output/lib -type d -path '*/pkgconfig'
+ export PKG_CONFIG_PATH=:/gramine/meson_build_output/lib/x86_64-linux-gnu/pkgconfig
+ PKG_CONFIG_PATH=:/gramine/meson_build_output/lib/x86_64-linux-gnu/pkgconfig
+ '[' -z '' ']'
+ gramine-sgx-get-token --sig /entrypoint.sig --output /entrypoint.token
Attributes:
    mr_enclave:  69495760bb621c92a58c14a8714f1659a04c01f89e67dfb78e98335e73aecbae
    mr_signer:   574a1cea1242646995442853c428a5485423af053f74cf3783010ef5c7d40df4
    isv_prod_id: 0
    isv_svn:     0
    attr.flags:  0000000000000004
    attr.xfrm:   00000000000000e7
    mask.flags:  ffffffffffffffff
    mask.xfrm:   fffffffffff9ff1b
    misc_select: 00000000
    misc_mask:   ffffffff
    modulus:     8f7a60cbb1bc08e4a7c72998b928324a...
    exponent:    3
    signature:   29d2819a8de56ecf5579e631f4782214...
    date:        2021-11-26
...
...
...
[ INFO ] Preparing input blobs
[ INFO ] Batch size is 1
[ INFO ] Preparing output blobs
[ INFO ] Loading model to the device
[ INFO ] Load Model successful
Start processing images: street.jpg
[ INFO ] Create infer request
[ WARNING ] Image is resized from (872, 586) to (300, 300)
[ INFO ] Batch size is 1
[ INFO ] Start inference
[ INFO ] Processing output blobs
[13,7] element, prob = 0.99149    (558,200)-(798,358) batch id : 0
[14,7] element, prob = 0.974486    (272,208)-(459,350) batch id : 0
[15,7] element, prob = 0.971601    (748,203)-(869,342) batch id : 0
[16,7] element, prob = 0.944048    (467,208)-(606,336) batch id : 0
[115,15] element, prob = 0.8783    (165,143)-(301,403) batch id : 0
[ INFO ] Image /home/openvino/output/street.bmp created!
[ INFO ] Execution successful
Openvino Success: Generated output file: street.bmp
```

Note that the above snippet only shows the start and end of the log.

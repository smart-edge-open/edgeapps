```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

## Core Network 5G – AMF/SMF
AMF/SMF can be deployed currently as kubevirt virtual machine. This directory contains script that will in VM image preparation. The image is based on Ubuntu 18.04.

### Build script
`build_amf_smf_image.sh` shell script in a few steps helps to prepare VM image that can be used for AMF/SMF deployment.

### Prerequisites
The script requires several libvirt packets to be installed:

`yum install -y qemu-kvm libvirt libvirt-python libguestfs-tools virt-install`

After that start libvirt as a service:

```sh
systemctl enable libvirtd
systemctl start libvirtd
```

Commands used for image resizing require also e2fsck library to be in at least 1.43 version. CentOS 7 has usually 1.42 in its repository so in that case it needs to be built from sources. Below are the commands required for installation:

```sh
wget http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.9.tar.gz
tar zxvf e2fsprogs-1.43.9.tar.gz
cd e2fsprogs-1.43.9
./configure
make
make install
```

It is require also to have FlexCORE binaries already downloaded.

### Running the script
Script takes two parameters - one is the destination path for the image and second is the path to the FlexCORE binaries directory. Usage looks like:

```sh
./build_amf_smf_image.sh <ubuntu_image_dest_dir> <astri_dir>
```

As a result after successful run, customized image ready to be used by kubevirt virtual machine should be created in destination path.

Image is based on *Ubuntu 18.04 LTS Minimal* image provided by Ubuntu site.

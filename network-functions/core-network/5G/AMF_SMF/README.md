```text
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2020 Intel Corporation
```

## Core Network 5G – AMF/SMF
AMF/SMF can be deployed  as pod on OpenNESS.
Before deploying AMF-SMF pod first generate amf-smf docker image.

### Build script
`build_image.sh` shell script in a few steps helps to prepare docker image that can be used for AMF/SMF deployment. 
Before running the script, create a subdirectory and copy the binary files to it.


```sh
./build_image.sh -b <Subdirectory which contains binary files for AMF-SMF>
```

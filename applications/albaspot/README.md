```
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2021 Albora Technologies Ltd.
```

# Albora Overview

Albora Technologies develops next-generation high-accuracy geolocation
solutions for industrial and mass-market applications. The company's
technologies offer fast, high-accuracy, software-based and
hardware-agnostic GNSS solutions, enabling customers to obtain better
geolocation information that is reliable, safe and secure. Our products
are especially suited for tracking assets in challenging environments,
such as urban areas or industrial/infrastructure complexes, where
certainty of the asset location is important.

Founded in 2017, the company is headquartered in London, United
Kingdom, and has an office in Barcelona, Spain.

For more information on Albora Technologies, please visit our
website: [Albora Technologies](https://albora.io)

# AlbaSpot Overview

AlbaSpot is an affordable geolocation edge/cloud-based corrections service
that provides continuous high-accuracy positioning. Its features include:

* High-accuracy: centimetre-level accuracy in real time
* Multi-constellation: supports GPS, Galileo, Beidou aand Glonass
* Multi-frequency: supports L1, L2 and L5
* Customizable: processing can be ported across edge, cloud and private data centers
* Standardized: compatible with standard communication protocols (NTRIP/RTCM)
* Fast and reliable: low latency due to optimized network design
* Hardware agnostic: supports all third-party NTRIP/RTCM-compatible devices in the market

## Installing the AlbaSpot Edge chart

The Helm charts for deploying the AlbaSpot application on the edge node
can be found here: https://github.com/open-ness/edgeapps/tree/master/applications/albaspot

You need to pull and load the appropriate docker images to deploy the system. Please
contact [Albora Technologies](https://albora.io) for information on how to obtain the
images.

The installation is performed by executing the following commands:

```
$ cd edgeapps/applications/albaspot/
$ helm dep update
$ helm install albaspot-edge helm-chart/
```

Please check the [values.yaml](./helm-chart/values.yaml) file for details about the settings
that need to be configured.

## Uninstalling the AlbaSpot application

To uninstall the application, execute the following command:

```
$ helm uninstall albaspot-edge
```

# Additional information

You can get more information about Albora Technologies and their products at
[https://albora.io](https://albora.io). For purchasing info, you may also reach
out to [sales@albora.io](mailto:sales@albora.io).


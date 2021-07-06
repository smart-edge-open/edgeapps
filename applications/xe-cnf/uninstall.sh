# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Exium Inc.


helm -n production uninstall n3iwf-eap5g upf-n4fe exe-health n3iwf-n2fe
helm -n exopsagent uninstall fluentd jaeger prometheus redis nats
istioctl manifest generate -f lib/istioctl_default_exedge.yaml | kubectl delete --ignore-not-found=true -f -
helm -n default uninstall nfs-subdir-external-provisioner 
kubectl -n production delete all --all
kubectl -n exopsagent delete all --all
kubectl -n istio-system delete all --all
kubectl delete namespace production exopsagent istio-system

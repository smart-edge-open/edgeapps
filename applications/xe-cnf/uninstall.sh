# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Exium Inc.


helm -n production uninstall n3iwf-eap5g n3iwf-n2ctxt n3iwf-sess upf-n4fe upf-sess exe-health n3iwf-n2fe upf-dns upf-fpm
helm -n exopsagent uninstall exmw-cfgagent exmw-subagent fluentd jaeger prometheus redis nats
istioctl manifest generate -f lib/istioctl_default_exedge.yaml | kubectl delete --ignore-not-found=true -f -
helm -n default uninstall nfs-subdir-external-provisioner 
kubectl -n production delete all --all
kubectl -n exopsagent delete all --all
kubectl -n istio-system delete all --all
kubectl delete namespace production exopsagent istio-system

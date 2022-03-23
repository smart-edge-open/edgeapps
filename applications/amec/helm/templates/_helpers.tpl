{{- /*
Copyright A5G Networks Inc.
 */}}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "a5gblu-mme.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "." "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the complete image url.
*/}}
{{- define "a5gblu.imageUrl" -}}
{{- if .Values.global.image.registryUrl }} 
{{- .Values.global.image.registryUrl }}/{{ .Values.global.image.name }}:{{ $.Chart.Version }} 
{{- else }}
{{- .Values.global.image.name }}:{{ $.Values.global.image.tag }}
{{- end }}
{{- end }}

{{/*
Create configmap prefix 
*/}}
{{- define "a5gblu.configmapPrefix" -}}
{{- $chart := include "a5gblu.chart" $ }} 
{{- printf "%s-%s" $chart "configmap" }}
{{- end }}

{{/*
Create service name prefix 
*/}}
{{- define "a5gblu.svcPrefix" -}}
{{- $chart := include "a5gblu.chart" . }} 
{{- printf "%s-%s" $chart "service" }}
{{- end }}

{{/*
Create mongo service name 
*/}}
{{- define "a5gblu.mongosvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "mongo" }}
{{- end }}

{{/*
Create hss service name 
*/}}
{{- define "a5gblu.hsssvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "hss" }}
{{- end }}

{{/*
Create mme service name 
*/}}
{{- define "a5gblu.mmesvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "mme" }}
{{- end }}

{{/*
Create sgwc service name 
*/}}
{{- define "a5gblu.sgwcsvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "sgwc" }}
{{- end }}

{{/*
Create sgwu service name 
*/}}
{{- define "a5gblu.sgwusvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "sgwu" }}
{{- end }}


{{/*
Create smf service name 
*/}}
{{- define "a5gblu.smfsvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "smf" }}
{{- end }}

{{/*
Create pcrf service name 
*/}}
{{- define "a5gblu.pcrfsvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "pcrf" }}
{{- end }}

{{/*
Create upf service name 
*/}}
{{- define "a5gblu.upfsvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "upf" }}
{{- end }}

{{/*
Create nrf service name 
*/}}
{{- define "a5gblu.nrfsvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "nrf" }}
{{- end }}

{{/*
Create webui service name 
*/}}
{{- define "a5gblu.webuisvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "webui" }}
{{- end }}

{{/*
Create podgw cl sidecar container
*/}}
{{- define "a5gblu.podgwSidecarDef" -}}
{{- if .Values.global.secgwEnabled }} 
- name: egresscl
  image: {{ .Values.global.image.podgw.name }}:{{ .Values.global.image.podgw.tag }}
  imagePullPolicy: {{ .Values.global.image.pullPolicy }}
  command:
    - /bin/egress_route_client.sh
  securityContext:
    privileged: true
    capabilities:
      add:
      - NET_ADMIN
  volumeMounts:
    - name: a5gblu-secgw-egress-config
      mountPath: /config
      readOnly: true
{{- end }}
{{- end }}

{{/*
Create podgw cl sidecar container volume
*/}}
{{- define "a5gblu.podgwSidecarVolumeDef" -}}
{{- if .Values.global.secgwEnabled }} 
- name: a5gblu-secgw-egress-config
  configMap:
    defaultMode: 365
    name: a5gblu-secgw-1-0-0-configmap-egress-cfg
{{- end }}
{{- end }}

{{/*
Create webui service name 
*/}}
{{- define "a5gblu.fluentbitSidecarDef" -}}
{{- if .Values.global.sidecar.fluentbit.enabled }} 
- name: fluentbit-sidecar
  image: {{ .Values.global.sidecar.fluentbit.image }}
  imagePullPolicy: IfNotPresent
  resources:
    limits:
      cpu: {{ .Values.global.sidecar.fluentbit.resources.limits.cpu }}
      memory: {{ .Values.global.sidecar.fluentbit.resources.limits.memory }}
  env:
    - name : A5GBLU_ELASTICSEARCH_HOST
      value: "{{ .Values.global.peer.esServiceName }}"
    - name : A5GBLU_ELASTICSEARCH_PORT
      value: "{{ .Values.global.peer.esServicePort }}"
  volumeMounts:
  - name: a5gblu-storage-log
    mountPath: /mnt/log
{{- end }}
{{- end }}

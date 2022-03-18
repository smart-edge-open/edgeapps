{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "a5gblu.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "." "-" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Expand the complete image url.
*/}}
{{- define "a5gblu.secgw.imageUrl" -}}
{{- if .Values.registryUrl }} 
{{- .Values.registryUrl }}/{{ .Values.image}}:{{ $.Chart.Version }} 
{{- else }}
{{- .Values.image }}:{{ $.Values.tag }}
{{- end }}
{{- end }}

{{/*
Expand the PODGW image url.
*/}}
{{- define "a5gblu.podgw.imageUrl" -}}
{{- if .Values.global.image.podgw.registryUrl }} 
{{- .Values.global.image.podgw.registryUrl }}/{{ .Values.global.image.podgw.name }}:{{ $.Chart.Version }} 
{{- else }}
{{- .Values.global.image.podgw.name }}:{{ $.Values.global.image.podgw.tag }}
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
Create secgw service name 
*/}}
{{- define "a5gblu.secgwsvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "secgw" }}
{{- end }}

{{/*
Create secgw eg service name 
*/}}
{{- define "a5gblu.secgwegsvc" -}}
{{- $chart := include "a5gblu.svcPrefix" . }} 
{{- printf "%s-%s" $chart "secgweg" }}
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



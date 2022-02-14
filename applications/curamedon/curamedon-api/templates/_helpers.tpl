# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2022 Inno Barn. All rights reserved.

{{/*
Expand the name of the chart.
*/}}
{{- define "curamedon-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "curamedon-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "curamedon-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
owner: curamedon-team
product: curamedon
{{- define "curamedon-api.labels" -}}
helm.sh/chart: {{ include "curamedon-api.chart" . }}
{{ include "curamedon-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "curamedon-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "curamedon-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "curamedon-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "curamedon-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
MySQL service
*/}}
{{- define "curamedon-api.mysqlHost" -}}
$({{ (upper .Values.mysqlServiceName) | replace "-" "_" }}_SERVICE_HOST):$({{ (upper .Values.mysqlServiceName) | replace "-" "_" }}_SERVICE_PORT)
{{- end }}

{{/*
Redis service
*/}}
{{- define "curamedon-api.redisHost" -}}
$({{ (upper .Values.redisServiceName) | replace "-" "_" }}_MASTER_SERVICE_HOST):$({{ (upper .Values.redisServiceName) | replace "-" "_" }}_MASTER_SERVICE_PORT)
{{- end }}

{{/*
Elasticsearch service hostaname
*/}}
{{- define "curamedon-api.elasticsearchHost" -}}
$({{ (upper .Values.elasticsearchServiceName) | replace "-" "_" }}_MASTER_SERVICE_HOST):$({{ (upper .Values.elasticsearchServiceName) | replace "-" "_" }}_MASTER_SERVICE_PORT)
{{- end }}

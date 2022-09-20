# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2022 Inno Barn. All rights reserved.

{{/*
Expand the name of the chart.
*/}}
{{- define "curamedon-backoffice.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "curamedon-backoffice.fullname" -}}
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
{{- define "curamedon-backoffice.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "curamedon-backoffice.labels" -}}
helm.sh/chart: {{ include "curamedon-backoffice.chart" . }}
{{ include "curamedon-backoffice.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "curamedon-backoffice.selectorLabels" -}}
app.kubernetes.io/name: {{ include "curamedon-backoffice.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "curamedon-backoffice.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "curamedon-backoffice.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
MySQL service
*/}}
{{- define "curamedon-backoffice.mysqlHost" -}}
$({{ (upper .Values.mysqlServiceName) | replace "-" "_" }}_SERVICE_HOST):$({{ (upper .Values.mysqlServiceName) | replace "-" "_" }}_SERVICE_PORT)
{{- end }}

# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2021 Blue Arcus Technologies, Inc

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "5gcore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "5gcore.fullname" -}}
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
{{- define "5gcore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "5gcore.labels" -}}
helm.sh/chart: {{ include "5gcore.chart" . }}
helm.sh/release: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end }}

{{/*
VY: This should be in common labels. Removed for now.
{{ include "5gcore.selectorLabels" . }}
*/}}

{{/*
Selector labels
*/}}

{{/*
VY: Commenting the Selector labels and serviceaccount name temporarily

{{- define "5gcore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "5gcore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "5gcore.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "5gcore.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

*/}}

{{/* Fullname suffixed with amf */}}
{{- define "5gcore.amf.fullname" -}}
{{- printf "%s-amf" (include "5gcore.fullname" .) }}
{{- end }}

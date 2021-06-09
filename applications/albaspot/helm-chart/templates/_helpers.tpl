{{/* SPDX-License-Identifier: Apache-2.0
     Copyright (c) 2021 Albora Technologies Ltd.
*/}}

{{/*
  Expand the name of the chart
*/}}
{{- define "product.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
  Create a default fully qualified app name.
  We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
  If release name contains chart name it will be used as a full name.
*/}}
{{- define "product.fullname" -}}
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
  Create the image string for a deployment container.
  A context with the container image and version is expected as a parameter.
  The image path is built from the registry and an optional addtional path.
*/}}
{{- define "docker.image" }}
  {{- printf "%s:%s" .image .version }}
{{- end }}

{{- define "docker.path" }}
  {{- if $registry := .Values.image.registry }}
    {{- if $slug := .Values.image.slug }}
      {{- printf "%s/%s/" $registry $slug }}
    {{- else }}
      {{- printf "%s/" $registry }}
    {{- end }}
  {{- end }}
{{- end }}

{{/*
  Create the secrets to access docker registry.
*/}}
{{- define "container.credentials" }}
  {{- with .Values.image }}
    {{- if .registry }}
      {{- printf "{\"auths\":{\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}}}" .registry .username .password .email (printf "%s:%s" .username .password | b64enc) | b64enc }}
    {{- end }}
  {{- end }}
{{- end }}
{{- define "container.pullSecret" }}
  {{- if .Values.image }}
    {{- if .Values.image.registry }}
      {{- $credentials := printf "- name: %s-docker-credentials" (include "product.fullname" .) }}
      {{- printf "imagePullSecrets:%s" ($credentials | nindent 2) | nindent 6 }}
    {{- end }}
  {{- end }}
{{- end }}

{{/*
  Retrieve the NodePort for the caster
*/}}
{{- define "caster.nodePort" }}
  {{- with .Values.ingress.controller }}
    {{- with .service }}
      {{- range $port := .tcpPorts }}
        {{- if eq $port.name "caster" }}
          {{- printf "%d" (int $port.nodePort) }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}

{{/*
  Generate the storage class name template for the db persistence
  The context value is expected to be map with service database fields
*/}}
{{- define "db.storageClass" }}
  {{- if .storageClass }}
    {{- .storageClass }}
  {{- else if .storageHostPath }}
    {{- printf "{{- include \"product.fullname\" . }}-%s-dbstorage" .instance }}
  {{- end }}
{{- end }}


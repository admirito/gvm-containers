{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gvm.name" -}}
{{- default .Chart.Name .Values.applicationName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gvm.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "gvm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a unique application instance name
*/}}
{{- define "gvm.instance" -}}
{{- $instanceSuffix := .Release.Name -}}
{{- if .Values.instanceSuffix -}}
{{- $instanceSuffix = printf "%s-%s" .Release.Name .Values.instanceSuffix -}}
{{- end -}}
{{- if .Values.partOf -}}
{{- printf "%s-%s" (tpl .Values.partOf .) $instanceSuffix | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "gvm.name" .) $instanceSuffix | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Generate PostgreSQL secret name
*/}}
{{- define "gvmd.dbSecretName" -}}
{{- default (printf "%s-%s" .Release.Name "gvmd-db") (index .Values "gvmd-db" "existingSecret") -}}
{{- end -}}

{{/*
Generate the chart secret name
*/}}
{{- define "gvmd.secretName" -}}
{{- default (include "gvm.fullname" .) (.Values.secrets.existingSecret) -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "gvm.labels" -}}
app.kubernetes.io/name: {{ include "gvm.name" . }}{{- if (not (empty .applicationNameSuffix)) }}-{{ .applicationNameSuffix }}{{- end }}
helm.sh/chart: {{ include "gvm.chart" . }}
app.kubernetes.io/instance: {{ include "gvm.instance" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.partOf }}
app.kubernetes.io/part-of: {{ tpl .Values.partOf . }}
{{- end }}
{{- end -}}

{{/*
The prefix for subPath values in volumeMounts
*/}}
{{- define "gvm.dataSubPathPrefix" -}}
{{- if .Values.dataSubPathPrefix }}
{{- printf "%s/" (tpl .Values.dataSubPathPrefix .) -}}
{{- end }}
{{- end -}}

{{/*
Generate a list of environment variables for feed synchronization
*/}}
{{- define "gvm.feedEnvList" -}}
{{- if .Values.customFeedsServer.enabled -}}
- name: COMMUNITY_NVT_RSYNC_FEED
  value: rsync://{{ include "gvm.fullname" . }}-feeds-server:{{ .Values.customFeedsServer.service.port }}/nvt-feed
- name: COMMUNITY_CERT_RSYNC_FEED
  value: rsync://{{ include "gvm.fullname" . }}-feeds-server:{{ .Values.customFeedsServer.service.port }}/cert-data
- name: COMMUNITY_SCAP_RSYNC_FEED
  value: rsync://{{ include "gvm.fullname" . }}-feeds-server:{{ .Values.customFeedsServer.service.port }}/scap-data
- name: COMMUNITY_GVMD_DATA_RSYNC_FEED
  value: rsync://{{ include "gvm.fullname" . }}-feeds-server:{{ .Values.customFeedsServer.service.port }}/data-objects/gvmd/
{{- end -}}
{{- end -}}

{{/*
Generate shell commands to be executed for feed synchronization
*/}}
{{- define "gvm.feedSyncShellCommands" -}}
{{- if .Values.customFeedsServer.enabled -}}
while ! timeout 5s bash -c "</dev/tcp/{{ include "gvm.fullname" . }}-feeds-server/{{ .Values.customFeedsServer.service.port }}"; do
    sleep 1
done
{{- end }}
greenbone-nvt-sync
greenbone-feed-sync --type CERT
greenbone-feed-sync --type SCAP
greenbone-feed-sync --type GVMD_DATA
{{- end -}}

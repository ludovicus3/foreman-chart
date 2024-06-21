{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Override upstream redis chart naming
*/}}
{{- define "redis.secretName" -}}
{{ template "foreman.redis.password.secret" . }}
{{- end -}}

{{/*
Override upstream redis secret key name
*/}}
{{- define "redis.secretPasswordKey" -}}
{{ template "foreman.redis.password.key" . }}
{{- end -}}
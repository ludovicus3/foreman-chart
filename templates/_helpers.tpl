{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- if .Component -}}
{{-   $name := default .Chart.Name .Values.nameOverride -}}
{{-   printf "%s-%s" $name .component | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{-   default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
{{- if and (hasKey . "component") (hasKey . "context") -}}
{{-   $name := default .context.Chart.Name .context.Values.nameOverride -}}
{{-   printf "%s-%s-%s" .context.Release.Name $name .component | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{-   $name := default .Chart.Name .Values.nameOverride -}}
{{-   printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end -}}
{{- end -}}

{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "component" -}}
{{- $component := base .Template.BasePath -}}
{{- if eq $component "templates" -}}
{{-   $component = "" -}}
{{- end -}}
{{- $component -}}
{{- end -}}

{{- define "labels.standard" -}}
app.kubernetes.io/name: {{ template "name" . }}
{{- if .Component }}
app.kubernetes.io/component: {{ .Component }}
{{- end }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ template "chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
helm.sh/root: {{ $.Chart.Name }}
{{- end -}}

{{- define "labels" -}}
{{- if and (hasKey . "component") (hasKey . "context") -}}
app.kubernetes.io/name: {{ template "name" .context }}
helm.sh/chart: {{ template "chart" .context }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
app.kubernetes.io/component: {{ .component }}
{{- else -}}
app.kubernetes.io/name: {{ template "name" . }}
helm.sh/chart: {{ template "chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end -}}
{{- end -}}

{{- define "labels.selectors" -}}
{{- if and (hasKey . "component") (hasKey . "context") -}}
app.kubernetes.io/name: {{ template "name" .context }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
app.kubernetes.io/component: {{ .component }}
{{- else -}}
app.kubernetes.io/name: {{ template "name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
{{- end -}}

{{/* annotations */}}

{{- define "foreman.serviceAnnotations" -}}
{{- $allAnnotations := merge (default (dict) (default (dict) .Values.service).annotations) .Values.global.service.annotations -}}
{{- if $allAnnotations -}}
{{-   range $key, $value := $allAnnotations }}
{{ $key }}: {{ $value | quote }}
{{-   end }}
{{- end -}}
{{- end -}}

{{- define "foreman.deploymentAnnotations" -}}
{{- $allAnnotations := merge (default (dict) (default (dict) .Values.deployment).annotations) .Values.global.deployment.annotations -}}
{{- if $allAnnotations -}}
{{-   range $key, $value := $allAnnotations }}
{{ $key }}: {{ $value | quote }}
{{-   end }}
{{- end -}}
{{- end -}}

{{/* labels */}}



{{- define "foreman.priorityClassName" -}}
{{- $priorityClassName := default .Values.global.priorityClassName .Values.priorityClassName -}}
{{- if $priorityClassName }}
priorityClassName: {{ $priorityClassName }}
{{- end -}}
{{- end -}}
{{- define "smartproxy.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-smartproxy" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "smartproxy.configMapName" -}}
{{- printf "%s-smartproxy" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "smartproxy.selectorLabels" -}}
{{- template "foreman.selectorLabels" . }}
app.kubernetes.io/component: smartproxy
{{- end -}}

{{- define "smartproxy.servicePort" -}}
{{- default 443 .Values.global.smartproxy.servicePort -}}
{{- end -}}

{{- define "smartproxy.containerPort" -}}
{{- default 8443 .Values.global.smartproxy.containerPort -}}
{{- end -}}
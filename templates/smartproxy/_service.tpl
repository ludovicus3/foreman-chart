{{- define "smartproxy.service" -}}
{{ $context := dict "component" "smartproxy" "context" . }}
metadata:
  name: {{ template "fullname" $context }}
  namespace: {{ $.Release.Namespace }}
  labels:
    {{- include "labels" $context | nindent 4 }}
spec:
  type: ClusterIP
  ports:
  - port: {{ template "smartproxy.servicePort" }}
    targetPort: {{ template "smartproxy.containerPort" }}
    name: https
    protocol: TCP
  selector:
    {{- include "labels.selectors" $context | nindent 4 }}
{{- end -}}
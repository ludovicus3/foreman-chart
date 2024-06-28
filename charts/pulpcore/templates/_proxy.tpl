{{- define "pulpcore.proxy.serviceHost" -}}
{{- $context := dict "component" "proxy" "context" . -}}
{{- $fullname := include "fullname" $context -}}
{{- printf "%s.%s.svc.cluster.local" $fullname $.Release.Namespace -}}
{{- end -}}
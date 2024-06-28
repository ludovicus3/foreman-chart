{{- define "pulpcore.content.serviceHost" -}}
{{- $context := dict "component" "content" "context" . -}}
{{- $fullname := include "fullname" $context -}}
{{- printf "%s.%s.svc.cluster.local" $fullname $.Release.Namespace -}}
{{- end -}}
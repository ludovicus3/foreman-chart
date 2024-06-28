{{- define "pulpcore.api.serviceHost" -}}
{{- $context := dict "component" "api" "context" . -}}
{{- $fullname := include "fullname" $context -}}
{{- printf "%s.%s.svc.cluster.local" $fullname $.Release.Namespace -}}
{{- end -}}
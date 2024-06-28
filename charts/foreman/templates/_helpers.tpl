{{- define "foreman.serviceHost" -}}
{{- $name := "foreman" -}}
{{- printf "%s.%s.svc.cluster.local" $name $.Release.Namespace -}}
{{- end -}}

{{- define "foreman.ingressHost" -}}
foreman.todo.com
{{- end -}}
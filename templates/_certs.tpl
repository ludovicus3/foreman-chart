{{- define "certs.tlsSecretName" -}}
{{- printf "%s-tls" (include "fullname" . ) -}}
{{- end -}}
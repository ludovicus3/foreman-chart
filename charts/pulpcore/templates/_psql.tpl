{{- define "pulpcore.psql.database" -}}
{{- default "pulpcore" .Values.psql.database -}}
{{- end -}}

{{- define "pulpcore.psql.username" -}}
{{- $local := pluck "psql" .Values | first -}}
{{- coalesce (pluck "username" $local | first) "pulp" -}}
{{- end -}}

{{- define "pulpcore.psql.host" -}}
{{- end -}}

{{- define "pulpcore.psql.port" -}}
{{- end -}}
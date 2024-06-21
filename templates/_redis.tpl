{{/*
Build a dict of redis configuration values
*/}}
{{- define "foreman.redis.configMerge" -}}
{{- $_ := set $ "redisConfigName" (default "" $.redisConfigName) -}}
{{- $_ := set $ "usingOverride" (default false $.usingOverride) -}}
{{- $_ := unset $ "redisMergedConfig" -}}
{{- $_ := set $ "redisMergedConfig" (dict "redisConfigName" $.redisConfigName) -}}
{{- $hasOverrideSecret := false -}}
{{- if and $.Value.global.redis.redisYmlOverride $.redisConfigName -}}
{{-   $hasOverrideSecret = (kindIs "map" (dig $.redisConfigName "password" "" $.Values.global.redis.redisYmlOverride)) -}}
{{- end -}}
{{- range $want := list "host" "port" "scheme" "user" -}}
{{-     $_ := set $.redisMergedConfig $want (pluck $want (index $.Values.global.redis $.redisConfigName) $.Values.global.redis | first) -}}
{{- end -}}
{{- if and $hasOverrideSecret $.usingOverride -}}
{{-   $_ := set $.redisMergedConfig "password" (get (index $.Values.global.redis.redisYmlOverride $.redisConfigName) "password") -}}
{{- else if kindIs "map" (get (index $.Values.global.redis $.redisConfigName) "password")  -}}
{{-   $_ := set $.redisMergedConfig "password" (get (index $.Values.global.redis $.redisConfigName) "password") -}}
{{- else if (kindIs "map" (get $.Values.global.redis "password")) -}}
{{-   $_ := set $.redisMergedConfig "password" (get $.Values.global.redis "password") -}}
{{- else -}}
{{-   $_ := set $.redisMergedConfig "password" $.Values.global.redis.auth -}}
{{- end -}}
{{- range $key := keys $.Values.global.redis.auth -}}
{{-   if not (hasKey $.redisMergedConfig.password $key) -}}
{{-     $_ := set $.redisMergedConfig.password $key (index $.Values.global.redis.auth $key) -}}
{{-   end -}}
{{- end -}}
{{/*
Build a dict of Redis Sentinel configuration
- For simplicity, using different Sentinel passwords across instances is not allowed. .redisYmlOverride
  cannot be used.
*/}}
{{- if (kindIs "map" (get $.Values.global.redis "sentinelAuth")) -}}
{{-   $_ := set $.redisMergedConfig "sentinelAuth" (get $.Values.global.redis "sentinelAuth") -}}
{{- end -}}
{{- end -}}

{{/*
Return the redis password secret name
*/}}
{{- define "foreman.redis.password.secret" -}}
{{- include "foreman.redis.configMerge" . -}}
{{- default (printf "%s-redis-secret" .Release.Name) .redisMergedConfig.password.secret | quote -}}
{{- end -}}

{{/*
Return the redis password secret key
*/}}
{{- define "foreman.redis.password.key" -}}
{{- include "foreman.redis.configMerge" . -}}
{{- default "password" .redisMergedConfig.password.key | quote -}}
{{- end -}}

{{/*
Return a merged setting between global.redis.password.enabled,
global.redis.[subkey/"redisConfigName"].password.enabled, or
global.redis.auth.enabled
*/}}
{{- define "foreman.redis.password.enabled" -}}
{{- include "foreman.redis.configMerge" . -}}
{{ ternary "true" "" .redisMergedConfig.password.enabled }}
{{- end -}}

{{/*
Return the Redis Sentinel auth secret name
*/}}
{{- define "foreman.redis.sentinelAuth.secret" -}}
{{- include "foreman.redis.configMerge" . -}}
{{- default (printf "%s-redis-sentinel-secret" .Release.Name) .redisMergedConfig.sentinelAuth.secret | quote -}}
{{- end -}}

{{/*
Return a merged setting between global.redis.sentinelAuth.enabled,
global.redis.[subkey/"redisConfigName"].sentinelAuth.enabled,
global.redis.sentinelAuth.enabled
*/}}
{{- define "foreman.redis.sentinelAuth.enabled" -}}
{{- include "foreman.redis.configMerge" . -}}
{{ ternary "true" "" .redisMergedConfig.sentinelAuth.enabled }}
{{- end -}}

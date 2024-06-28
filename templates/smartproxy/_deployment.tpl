{{- define "smartproxy.deployment" -}}
{{- $context := dict "component" "smartproxy" "context" . -}}
metadata:
  name: {{ template "fullname" $context }}
  namespace: {{ $.Release.Namespace }}
  labels:
    {{- include "labels" $context | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "labels.selectors" $context | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "labels" $context | nindent 8 }}
    spec:
      containers:
        - name: smartproxy
          image: {{ .Values.global.smartproxy.image | quote }}
          command:
            - bundle
            - exec
            - bin/smart-proxy
          ports:
            - containerPort: {{ include "smartproxy.containerPort" . | int }}
              protocol: TCP
          volumeMounts:
            - name: config
              mountPath: /etc/foreman-proxy/settings.yml
              subPath: settings.yml
            - name: plugins
              mountPath: /etc/foreman-proxy/settings.d
            - name: tls
              mountPath: /etc/foreman-proxy/tls
      volumes:
      - name: tls
        secret:
          secretName: {{ template "certs.tlsSecretName" . }}
      - name: config
        configMap:
          name: {{ template "smartproxy.configMapName" . }}
      - name: plugins
        configMap:
          name: {{ template "fullname" $context }}
{{- end }}
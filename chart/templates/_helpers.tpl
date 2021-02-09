{{- /*
This should be used with the $ scope
*/}}
{{- define "redirect_url" }}
  {{- if .Values.sso.redirect_url -}}
    {{ tpl .Values.sso.redirect_url . }}
  {{- else -}}
    {{ tpl (index .Values.istio.kibana.hosts 0) .}}
  {{- end }}
{{- end }}
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

{{- define "oidc" }}
{{- with .Values.sso }}
xpack.security.authc.realms.oidc.{{ .oidc.realm }}:
  order: 2
  rp.client_id: {{ .client_id }}
  rp.response_type: code
  rp.requested_scopes:
    - openid
    - email
  rp.redirect_uri: "https://{{ template "redirect_url" $ }}/api/security/v1/oidc"
  rp.post_logout_redirect_uri: "https://{{ template "redirect_url" $ }}/logged_out"
  op.issuer: {{ tpl .issuer }}
  op.authorization_endpoint: {{ tpl .auth_url }}
  op.token_endpoint: {{ tpl .token_url }}
  op.userinfo_endpoint: {{ tpl .userinfo_url }}
  op.jwkset_path: {{ tpl .jwkset_url }}
  claims.principal: {{ .claims_principal }}
  claim_patterns.principal: {{ tpl .claims_principal_pattern }}
  rp.signature_algorithm: {{ .signature_algorithm }}
  op.endsession_endpoint: {{ tpl .endsession_url }}
  claims.groups: {{ .claims_group }}
  claims.mail: {{ .claims_mail }}
{{- end }}
{{- end }}
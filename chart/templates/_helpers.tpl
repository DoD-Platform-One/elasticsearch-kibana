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
  rp.requested_scopes: {{ toYaml .requested_scopes | indent 4 }}
  rp.redirect_uri: "https://{{ template "redirect_url" $ }}/api/security/v1/oidc"
  rp.post_logout_redirect_uri: "https://{{ template "redirect_url" $ }}/logged_out"
  op.issuer: {{ tpl .issuer $ }}
  op.authorization_endpoint: {{ tpl .auth_url $ }}
  op.token_endpoint: {{ tpl .token_url $ }}
  op.userinfo_endpoint: {{ tpl .userinfo_url $ }}
  op.jwkset_path: {{ tpl .jwkset_url $ }}
  claims.principal: {{ .claims_principal }}
  {{- /*Optional values should be nil checked*/ -}}
  {{- if and (.claims_principal_pattern) (ne .claims_principal_pattern "-") }}
  claim_patterns.principal: {{ .claims_principal_pattern }}
  {{- end }}
  {{- if and (.signature_algorithm) (ne .signature_algorithm "-") }}
  rp.signature_algorithm: {{ .signature_algorithm }}
  {{- end }}
  {{- if and (.endsession_url) (ne .endsession_url "-") }}
  op.endsession_endpoint: {{ tpl .endsession_url $ }}
  {{- end }}
  {{- if and (.claims_group) (ne .claims_group "-") }}
  claims.groups: {{ .claims_group }}
  {{- end }}
  {{- if and (.claims_mail) (ne .claims_mail "-") }}
  claims.mail: {{ .claims_mail }}
  {{- end }}
{{- end }}
{{- end }}
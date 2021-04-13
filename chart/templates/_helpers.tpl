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
xpack.security.authc.realms.oidc.google:
  order: 2
  rp.client_id: {{ .client_id }}
  rp.response_type: code
  rp.requested_scopes:
    - openid
    - email
  rp.redirect_uri: "https://{{ template "redirect_url" $ }}/api/security/v1/oidc"
  op.issuer: "https://accounts.google.com"
  op.authorization_endpoint: "https://accounts.google.com/o/oauth2/v2/auth"
  op.token_endpoint: "https://oauth2.googleapis.com/token"
  op.userinfo_endpoint: "https://openidconnect.googleapis.com/v1/userinfo"
  op.jwkset_path: "https://www.googleapis.com/oauth2/v3/certs"
  claims.principal: email
  claim_patterns.principal: "^([^@]+)@leapfrog\\.ai$"

# xpack.security.authc.realms.oidc.{{ .oidc.realm }}:
#   order: 2
#   rp.client_id: {{ .client_id }}
#   rp.response_type: code
#   rp.redirect_uri: "https://{{ template "redirect_url" $ }}/api/security/oidc/callback"
#   rp.signature_algorithm: RS256
#   rp.requested_scopes:
#     - openid
#   op.authorization_endpoint: "https://{{ .oidc.host }}/auth/realms/{{ .oidc.realm }}/protocol/openid-connect/auth"
#   op.token_endpoint: "https://{{ .oidc.host }}/auth/realms/{{ .oidc.realm }}/protocol/openid-connect/token"
#   op.jwkset_path: "https://{{ .oidc.host }}/auth/realms/{{ .oidc.realm }}/protocol/openid-connect/certs"
#   op.userinfo_endpoint: "https://{{ .oidc.host }}/auth/realms/{{ .oidc.realm }}/protocol/openid-connect/userinfo"
#   op.endsession_endpoint: "https://{{ .oidc.host }}/auth/realms/{{ .oidc.realm }}/protocol/openid-connect/logout"
#   op.issuer: "https://{{ .oidc.host }}/auth/realms/{{ .oidc.realm }}"
#   rp.post_logout_redirect_uri: "https://{{ template "redirect_url" $ }}/logged_out"
#   claims.principal: preferred_username
#   claims.groups: groups
#   claims.mail: email
{{- end }}
{{- end }}
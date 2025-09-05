{{/*
Build the Kibana spec.config by composing sane defaults and allowing users
to override via .Values.kibana.config. Uses mergeOverwrite for deep merge.
Outputs valid YAML (or {} when empty).
*/}}
{{- define "kibana.config" -}}
{{- $user := .Values.kibana.config | default dict | deepCopy -}}

{{- /* Start with chart-provided defaults */ -}}
{{- $cfg := dict -}}

{{- if and .Values.istio.enabled .Values.istio.elasticsearch.enabled -}}
  {{- $_ := set $cfg "elasticsearch.hosts" (list (printf "http://%s-es-http:9200" .Release.Name)) -}}
{{- end -}}

{{- if .Values.bbtests.enabled -}}
  {{- $_ := set $cfg "csp.strict" false -}}
{{- end -}}

{{- with .Values.sso }}
  {{- if .enabled }}
    {{- $_ := set $cfg "xpack.security.authc.providers" (dict
          "oidc.oidc1" (dict "enabled" true "order" 0 "realm" .oidc.realm)
        ) -}}
    {{- if $.Values.kibanaBasicAuth.enabled }}
      {{- $providers := get $cfg "xpack.security.authc.providers" | default dict -}}
      {{- $_ := set $providers "basic.basic1" (dict "enabled" true "order" 1) -}}
      {{- $_ := set $cfg "xpack.security.authc.providers" $providers -}}
    {{- end }}
  {{- end }}
{{- end }}

{{- /* server.publicBaseUrl */ -}}
{{- $server := dict -}}
{{- if .Values.kibana.host -}}
  {{- $_ := set $server "publicBaseUrl" (printf "https://%s" .Values.kibana.host) -}}
{{- else if .Values.istio.kibana.hosts -}}
  {{- $_ := set $server "publicBaseUrl" (printf "https://%s" (tpl (index .Values.istio.kibana.hosts 0) .)) -}}
{{- else -}}
  {{- $_ := set $server "publicBaseUrl" "https://kibana.bigbang.dev" -}}
{{- end -}}
{{- if gt (len $server) 0 -}}
  {{- $_ := set $cfg "server" $server -}}
{{- end -}}

{{- /* Optional Fleet config */ -}}
{{- if and .Values.kibana.agents.elasticsearchHosts .Values.kibana.agents.fleetserverHosts .Values.kibana.agents.packages .Values.kibana.agents.agentPolicies -}}
  {{- $_ := set $cfg "xpack.fleet.agents.elasticsearch.hosts" .Values.kibana.agents.elasticsearchHosts -}}
  {{- $_ := set $cfg "xpack.fleet.agents.fleet_server.hosts" .Values.kibana.agents.fleetserverHosts -}}
  {{- $_ := set $cfg "xpack.fleet.packages" .Values.kibana.agents.packages -}}
  {{- $_ := set $cfg "xpack.fleet.agentPolicies" .Values.kibana.agents.agentPolicies -}}
{{- end -}}

{{- /* Deep-merge user overrides last so they win */ -}}
{{- $out := mergeOverwrite (deepCopy $cfg) $user -}}

{{- /* Render YAML or {} if empty */ -}}
{{- if eq (len $out) 0 -}}
{}
{{- else -}}
{{ toYaml $out }}
{{- end -}}
{{- end -}}

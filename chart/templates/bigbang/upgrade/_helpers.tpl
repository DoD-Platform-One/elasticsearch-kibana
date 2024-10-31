{{- define "elasticsearch.shouldDeployUpgradeResources" -}}
{{/* Define upgradeVersion inside the template so it's available when the template is used */}}
{{- $upgradeVersion := "1.20.0-bb.0" -}}
{{- if and .Values.autoRollingUpgrade.enabled .Release.IsUpgrade .Values.metrics.enabled -}}
  {{- $Elasticsearch := lookup "elasticsearch.k8s.elastic.co/v1" "Elasticsearch" .Release.Namespace .Release.Name -}}
  {{- if $Elasticsearch -}}
    {{- $currentVersion := dig "metadata" "labels" "helm.sh/chart" "<missing>" $Elasticsearch | trimPrefix (print .Chart.Name "-") -}}
    {{- if semverCompare (print "<" $upgradeVersion) $currentVersion -}}
      true
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}
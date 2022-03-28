# logging

![Version: 0.7.0-bb.0](https://img.shields.io/badge/Version-0.7.0--bb.0-informational?style=flat-square) ![AppVersion: 7.17.1](https://img.shields.io/badge/AppVersion-7.17.1-informational?style=flat-square)

Configurable Deployment of Elasticsearch and Kibana Custom Resources Wrapped Inside a Helm Chart.

## Learn More
* [Application Overview](docs/overview.md)
* [Other Documentation](docs/)

## Pre-Requisites

* Kubernetes Cluster deployed
* Kubernetes config installed in `~/.kube/config`
* Helm installed

Install Helm

https://helm.sh/docs/intro/install/

## Deployment

* Clone down the repository
* cd into directory
```bash
helm install logging chart/
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| hostname | string | `"bigbang.dev"` | Domain used for BigBang created exposed services. |
| autoRollingUpgrade.enabled | bool | `true` | Enable BigBang specific autoRollingUpgrade support |
| imagePullPolicy | string | `"IfNotPresent"` | Pull Policy for all non-init containers in this package. |
| kibana.version | string | `"7.17.1"` | version |
| kibana.image.repository | string | `"registry1.dso.mil/ironbank/elastic/kibana/kibana"` | repository |
| kibana.image.tag | string | `"7.17.1"` | tag |
| kibana.host | string | `""` | Only required if not using Istio for ingress. |
| kibana.count | int | `3` | Number of Kibana replicas |
| kibana.serviceAccountName | string | `"logging-kibana"` | Name for serviceAccount to use, will be autocreated. |
| kibana.updateStrategy.type | string | `"rollingUpdate"` | type |
| kibana.updateStrategy.rollingUpdate.maxUnavailable | int | `1` | maxUnavailable |
| kibana.securityContext.runAsUser | int | `1000` | runAsUser |
| kibana.securityContext.runAsGroup | int | `1000` | runAsGroup |
| kibana.securityContext.fsGroup | int | `1000` | fsGroup |
| kibana.imagePullSecrets | list | `[]` | imagePullSecrets |
| kibana.resources.requests.cpu | int | `1` | CPU request |
| kibana.resources.requests.memory | string | `"2Gi"` | Memory request |
| kibana.resources.limits.cpu | int | `1` | CPU limit |
| kibana.resources.limits.memory | string | `"2Gi"` | Memory limit |
| kibana.volumes | list | `[]` | volumes |
| kibana.volumeMounts | list | `[]` | volumeMounts |
| kibana.podAnnotations | object | `{}` | podAnnotations |
| kibana.affinity | object | `{}` | affinity |
| kibana.tolerations | list | `[]` | tolerations |
| kibana.nodeSelector | object | `{}` | nodeSelector |
| kibana.lifecycle | object | `{}` | lifecycle |
| elasticsearch.version | string | `"7.17.1"` | version |
| elasticsearch.image.repository | string | `"registry1.dso.mil/ironbank/elastic/elasticsearch/elasticsearch"` | repository |
| elasticsearch.image.tag | string | `"7.17.1"` | tag |
| elasticsearch.imagePullSecrets | list | `[]` | imagePullSecrets |
| elasticsearch.serviceAccountName | string | `"logging-elasticsearch"` | Name for serviceAccount to use, will be autocreated. |
| elasticsearch.master.initContainers | list | `[]` | Add an init container that adjusts the kernel setting for elastic. |
| elasticsearch.master.securityContext.runAsUser | int | `1000` | runAsUser |
| elasticsearch.master.securityContext.runAsGroup | int | `1000` | runAsGroup |
| elasticsearch.master.securityContext.fsGroup | int | `1000` | fsGroup |
| elasticsearch.master.updateStrategy.type | string | `"rollingUpdate"` | type |
| elasticsearch.master.updateStrategy.rollingUpdate.maxUnavailable | int | `1` | maxUnavailable |
| elasticsearch.master.volumes | list | `[]` | volumes |
| elasticsearch.master.volumeMounts | list | `[]` | volumeMounts |
| elasticsearch.master.podAnnotations | object | `{}` | podAnnotations |
| elasticsearch.master.affinity | object | `{}` | affinity |
| elasticsearch.master.tolerations | list | `[]` | tolerations |
| elasticsearch.master.nodeSelector | object | `{}` | nodeSelector |
| elasticsearch.master.lifecycle | object | `{}` | lifecycle |
| elasticsearch.master.count | int | `3` | count |
| elasticsearch.master.persistence.storageClassName | string | `""` | storageClassName |
| elasticsearch.master.persistence.size | string | `"5Gi"` | size |
| elasticsearch.master.resources.limits.cpu | int | `1` | CPU limit |
| elasticsearch.master.resources.limits.memory | string | `"4Gi"` | Memory limit |
| elasticsearch.master.resources.requests.cpu | int | `1` | CPU request |
| elasticsearch.master.resources.requests.memory | string | `"4Gi"` | Memory request |
| elasticsearch.master.heap.min | string | `"2g"` | Xms |
| elasticsearch.master.heap.max | string | `"2g"` | Xmx |
| elasticsearch.data.initContainers | list | `[]` | Add an init container that adjusts the kernel setting for elastic. |
| elasticsearch.data.securityContext.runAsUser | int | `1000` | runAsUser |
| elasticsearch.data.securityContext.runAsGroup | int | `1000` | runAsGroup |
| elasticsearch.data.securityContext.fsGroup | int | `1000` | fsGroup |
| elasticsearch.data.volumes | list | `[]` | volumes |
| elasticsearch.data.volumeMounts | list | `[]` | volumeMounts |
| elasticsearch.data.podAnnotations | object | `{}` | podAnnotations |
| elasticsearch.data.affinity | object | `{}` | affinity |
| elasticsearch.data.tolerations | list | `[]` | tolerations |
| elasticsearch.data.nodeSelector | object | `{}` | nodeSelector |
| elasticsearch.data.lifecycle | object | `{}` | lifecycle |
| elasticsearch.data.count | int | `4` | count |
| elasticsearch.data.persistence.storageClassName | string | `""` | storageClassName |
| elasticsearch.data.persistence.size | string | `"100Gi"` | size |
| elasticsearch.data.resources.limits.cpu | int | `1` | CPU limits |
| elasticsearch.data.resources.limits.memory | string | `"4Gi"` | Memory limits |
| elasticsearch.data.resources.requests.cpu | int | `1` | CPU requests |
| elasticsearch.data.resources.requests.memory | string | `"4Gi"` | Memory requests |
| elasticsearch.data.heap.min | string | `"2g"` | Xms |
| elasticsearch.data.heap.max | string | `"2g"` | Xmx |
| elasticsearch.ingest.enabled | bool | `false` | enabled |
| elasticsearch.ingest.initContainers | list | `[]` | initContainers |
| elasticsearch.ingest.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Add ability customize the security context for fixing user or group. |
| elasticsearch.ingest.securityContext.runAsUser | int | `1000` | runAsUser |
| elasticsearch.ingest.securityContext.runAsGroup | int | `1000` | runAsGroup |
| elasticsearch.ingest.securityContext.fsGroup | int | `1000` | fsGroup |
| elasticsearch.ingest.volumes | list | `[]` | volumes |
| elasticsearch.ingest.volumeMounts | list | `[]` | volumeMounts |
| elasticsearch.ingest.podAnnotations | object | `{}` | podAnnotations |
| elasticsearch.ingest.affinity | object | `{}` | affinity |
| elasticsearch.ingest.tolerations | list | `[]` | tolerations |
| elasticsearch.ingest.nodeSelector | object | `{}` | nodeSelector |
| elasticsearch.ingest.lifecycle | object | `{}` | lifecycle |
| elasticsearch.ingest.count | int | `1` | count |
| elasticsearch.ingest.persistence.storageClassName | string | `""` | storageClassName |
| elasticsearch.ingest.persistence.size | string | `"100Gi"` | size |
| elasticsearch.ingest.resources.limits.cpu | int | `1` | CPU limits |
| elasticsearch.ingest.resources.limits.memory | string | `"4Gi"` | Memory limits |
| elasticsearch.ingest.resources.requests.cpu | int | `1` | CPU requests |
| elasticsearch.ingest.resources.requests.memory | string | `"4Gi"` | Memory requests |
| elasticsearch.ingest.heap.min | string | `"2g"` | Xms |
| elasticsearch.ingest.heap.max | string | `"2g"` | Xmx |
| elasticsearch.ml.enabled | bool | `false` | enabled |
| elasticsearch.ml.initContainers | list | `[]` | initContainers |
| elasticsearch.ml.securityContext.runAsUser | int | `1000` | runAsUser |
| elasticsearch.ml.securityContext.runAsGroup | int | `1000` | runAsGroup |
| elasticsearch.ml.securityContext.fsGroup | int | `1000` | fsGroup |
| elasticsearch.ml.updateStrategy.type | string | `"rollingUpdate"` |  |
| elasticsearch.ml.updateStrategy.rollingUpdate.maxUnavailable | int | `1` | maxUnavailable |
| elasticsearch.ml.volumes | list | `[]` | volumes |
| elasticsearch.ml.volumeMounts | list | `[]` | volumeMounts |
| elasticsearch.ml.podAnnotations | object | `{}` | podAnnotations |
| elasticsearch.ml.affinity | object | `{}` | affinity |
| elasticsearch.ml.tolerations | list | `[]` | tolerations |
| elasticsearch.ml.nodeSelector | object | `{}` | nodeSelector |
| elasticsearch.ml.lifecycle | object | `{}` | lifecycle |
| elasticsearch.ml.count | int | `1` | count |
| elasticsearch.ml.persistence.storageClassName | string | `""` | storageClassName |
| elasticsearch.ml.persistence.size | string | `"100Gi"` | size |
| elasticsearch.ml.resources.limits.cpu | int | `1` | CPU limits |
| elasticsearch.ml.resources.limits.memory | string | `"4Gi"` | Memory limits |
| elasticsearch.ml.resources.requests.cpu | int | `1` | CPU requests |
| elasticsearch.ml.resources.requests.memory | string | `"4Gi"` | Memory requests |
| elasticsearch.ml.heap.min | string | `"2g"` |  |
| elasticsearch.ml.heap.max | string | `"2g"` | Xmx |
| elasticsearch.coord.enabled | bool | `false` | enabled |
| elasticsearch.coord.initContainers | list | `[]` | initContainers |
| elasticsearch.coord.securityContext.runAsUser | int | `1000` | runAsUser |
| elasticsearch.coord.securityContext.runAsGroup | int | `1000` | runAsGroup |
| elasticsearch.coord.securityContext.fsGroup | int | `1000` | fsGroup |
| elasticsearch.coord.updateStrategy.type | string | `"rollingUpdate"` | type |
| elasticsearch.coord.updateStrategy.rollingUpdate.maxUnavailable | int | `1` | maxUnavailable |
| elasticsearch.coord.volumes | list | `[]` | volumes |
| elasticsearch.coord.volumeMounts | list | `[]` | volumeMounts |
| elasticsearch.coord.podAnnotations | object | `{}` | podAnnotations |
| elasticsearch.coord.affinity | object | `{}` | affinity |
| elasticsearch.coord.tolerations | list | `[]` | tolerations |
| elasticsearch.coord.nodeSelector | object | `{}` | nodeSelector |
| elasticsearch.coord.lifecycle | object | `{}` | lifecycle |
| elasticsearch.coord.count | int | `1` | count |
| elasticsearch.coord.persistence.storageClassName | string | `""` | storageClassName |
| elasticsearch.coord.persistence.size | string | `"100Gi"` | size |
| elasticsearch.coord.resources.limits.cpu | int | `1` | cpu limits |
| elasticsearch.coord.resources.limits.memory | string | `"4Gi"` | memory limits |
| elasticsearch.coord.resources.requests.cpu | int | `1` | cpu requests |
| elasticsearch.coord.resources.requests.memory | string | `"4Gi"` | memory requests |
| elasticsearch.coord.heap.min | string | `"2g"` | Xms |
| elasticsearch.coord.heap.max | string | `"2g"` | Xmx |
| istio.enabled | bool | `false` | Toggle istio interaction. |
| istio.kibana.enabled | bool | `true` | Toggle virtualService creation |
| istio.kibana.annotations | object | `{}` | Annotations for controls the gateway used/attached to the virtualService |
| istio.kibana.labels | object | `{}` | Labels for virtualService |
| istio.kibana.gateways | list | `["istio-system/main"]` | Gateway(s) to apply virtualService routes to. |
| istio.kibana.hosts[0] | string | `"kibana.{{ .Values.hostname }}"` | hosts |
| sso.enabled | bool | `false` | Toggle and configure SSO with Keycloak. Example values are for local development. |
| sso.redirect_url | string | `""` | redirect_url defaults to .Values.istio.kibana.hosts[0] if not set. |
| sso.client_id | string | `"platform1_a8604cc9-f5e9-4656-802d-d05624370245_bb8-kibana"` | client_id |
| sso.client_secret | string | `""` | OIDC client secret, can be empty for public client. |
| sso.oidc.host | string | `"login.dso.mil"` | host |
| sso.oidc.realm | string | `"baby-yoda"` | realm |
| sso.issuer | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}"` |  |
| sso.auth_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/auth"` | auth_url |
| sso.token_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/token"` | token_url |
| sso.userinfo_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/userinfo"` | userinfo_url |
| sso.jwkset_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/certs"` | jwks_url |
| sso.claims_principal | string | `"preferred_username"` | claims_principal |
| sso.requested_scopes | list | `["openid"]` | requested_scopes |
| sso.signature_algorithm | string | `"RS256"` |  |
| sso.endsession_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/logout"` |  |
| sso.claims_group | string | `"groups"` | claims_group |
| sso.claims_mail | string | `"email"` | claims_mail |
| sso.claims_principal_pattern | string | `""` |  |
| sso.cert_authorities | list | `[]` | cert_authorities |
| kibanaBasicAuth.enabled | bool | `true` | Toggle this to turn off Kibana's built in auth and only allow SSO. Role mappings for SSO groups must be set up and SSO enabled before doing this. |
| networkPolicies.enabled | bool | `false` | enabled |
| networkPolicies.ingressLabels.app | string | `"istio-ingressgateway"` | app |
| networkPolicies.ingressLabels.istio | string | `"ingressgateway"` | istio |
| networkPolicies.controlPlaneCidr | string | `"0.0.0.0/0"` | See `kubectl cluster-info` and then resolve to IP |
| upgradeJob.image.repository | string | `"registry1.dso.mil/ironbank/big-bang/base"` | repository |
| upgradeJob.image.tag | float | `8.4` | tag |
| openshift | bool | `false` | Openshift Container Platform Feature Toggle |
| bbtests.enabled | bool | `false` |  |
| bbtests.cypress.artifacts | bool | `true` |  |
| bbtests.cypress.envs.cypress_expect_logs | string | `"false"` |  |
| bbtests.cypress.envs.cypress_kibana_url | string | `"https://logging-ek-kb-http:5601/login"` |  |
| bbtests.cypress.secretEnvs[0].name | string | `"cypress_elastic_password"` |  |
| bbtests.cypress.secretEnvs[0].valueFrom.secretKeyRef.name | string | `"logging-ek-es-elastic-user"` |  |
| bbtests.cypress.secretEnvs[0].valueFrom.secretKeyRef.key | string | `"elastic"` |  |
| bbtests.scripts.image | string | `"registry1.dso.mil/ironbank/stedolan/jq:1.6"` |  |
| bbtests.scripts.envs.elasticsearch_host | string | `"https://{{ .Release.Name }}-es-http.{{ .Release.Namespace }}.svc.cluster.local:9200"` |  |
| bbtests.scripts.envs.desired_version | string | `"{{ .Values.elasticsearch.version }}"` |  |
| bbtests.scripts.secretEnvs[0].name | string | `"ELASTIC_PASSWORD"` |  |
| bbtests.scripts.secretEnvs[0].valueFrom.secretKeyRef.name | string | `"logging-ek-es-elastic-user"` |  |
| bbtests.scripts.secretEnvs[0].valueFrom.secretKeyRef.key | string | `"elastic"` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.

<!-- Warning: Do not manually edit this file. See notes on gluon + helm-docs at the end of this file for more information. -->
# elasticsearch-kibana

![Version: 1.33.0-bb.0](https://img.shields.io/badge/Version-1.33.0--bb.0-informational?style=flat-square) ![AppVersion: 9.1.5](https://img.shields.io/badge/AppVersion-9.1.5-informational?style=flat-square) ![Maintenance Track: bb_integrated](https://img.shields.io/badge/Maintenance_Track-bb_integrated-green?style=flat-square)

Configurable Deployment of Elasticsearch and Kibana Custom Resources Wrapped Inside a Helm Chart.

## Upstream Release Notes

This chart has no upstream and is maintained entirely by the Big Bang team. It is
(usually) updated any time new versions of elasticsearch and kibana are released
upstream. The changelog for both can be found at the following places:

- [Elasticsearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html)
- [Kibana](https://www.elastic.co/guide/en/kibana/current/release-notes.html)

## Learn More

- [Application Overview](docs/overview.md)
- [Other Documentation](docs/)

## Pre-Requisites

- Kubernetes Cluster deployed
- Kubernetes config installed in `~/.kube/config`
- Helm installed

Install Helm

https://helm.sh/docs/intro/install/

## Deployment

- Clone down the repository
- cd into directory

```bash
helm install elasticsearch-kibana chart/
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| domain | string | `"dev.bigbang.mil"` | Domain used for BigBang created exposed services. |
| autoRollingUpgrade.enabled | bool | `true` | Enable BigBang specific autoRollingUpgrade support |
| imagePullPolicy | string | `"IfNotPresent"` | Pull Policy for all non-init containers in this package. |
| fluentbit | object | `{"enabled":false}` | Toggle for networkpolicies to allow fluentbit ingress |
| kibana.version | string | `"9.1.5"` | Kibana version |
| kibana.image.repository | string | `"registry1.dso.mil/ironbank/elastic/kibana/kibana"` | Kibana image repository |
| kibana.image.tag | string | `"9.1.5"` | Kibana image tag |
| kibana.host | string | `""` | Kibana Ingress Host Value. Only required if not using Istio for ingress. |
| kibana.count | int | `3` | Number of Kibana replicas |
| kibana.serviceAccountName | string | `"logging-kibana"` | Name for serviceAccount to use, will be autocreated. |
| kibana.serviceAccountAnnotations | object | `{}` | Annotations for the kibana service account. |
| kibana.updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"rollingUpdate"}` | Kibana updateStrategy |
| kibana.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Set securityContext for Kibana pods |
| kibana.containersecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| kibana.imagePullSecrets | list | `[]` | Kibana imagePullSecrets |
| kibana.resources | object | `{"limits":{"cpu":1,"memory":"2Gi"},"requests":{"cpu":1,"memory":"2Gi"}}` | Kibana resources |
| kibana.volumes | list | `[]` | Kibana volumes |
| kibana.volumeMounts | list | `[]` | Kibana volumeMounts |
| kibana.podAnnotations | object | `{}` | Kibana podAnnotations |
| kibana.affinity | object | `{}` | Kibana affinity |
| kibana.tolerations | list | `[]` | Kibana tolerations |
| kibana.nodeSelector | object | `{}` | Kibana nodeSelector |
| kibana.lifecycle | object | `{}` | Kibana lifecycle |
| kibana.config | object | `{}` | Additional Kibana configuration Notes:  - Any key you put here must match the Kibana config file format:    https://www.elastic.co/guide/en/kibana/current/settings.html  - Values here are deep-merged into the chart’s defaults in _kibana-config.tpl, so your custom config takes precedence  - If left empty (`{}`), the chart will apply its defaults in _kibana-config.tpl. |
| kibana.agents | object | `{}` | Kibana Elastic Agent / Fleet Server configuration https://www.elastic.co/guide/en/cloud-on-k8s/2.7/k8s-elastic-agent-fleet-quickstart.html |
| elasticsearch.version | string | `"9.1.5"` | Elasticsearch version |
| elasticsearch.image.repository | string | `"registry1.dso.mil/ironbank/elastic/elasticsearch/elasticsearch"` | Elasticsearch image repository |
| elasticsearch.image.tag | string | `"9.1.5"` | Elasticsearch image tag |
| elasticsearch.imagePullSecrets | list | `[]` | Elasticsearch imagePullSecrets |
| elasticsearch.serviceAccountName | string | `"logging-elasticsearch"` | Name for serviceAccount to use, will be autocreated. |
| elasticsearch.serviceAccountAnnotations | object | `{}` | Annotations for the elasticsearch service account. |
| elasticsearch.podDisruptionBudget | object | `{"enabled":true,"spec":{}}` | Elasticsearch podDisruptionBudget https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-pod-disruption-budget.html |
| elasticsearch.master.initContainers | list | `[]` | Add init containers to master pods |
| elasticsearch.master.config | object | `{"index.store.type":"mmapfs","node.roles":["master"],"node.store.allow_mmap":true,"xpack.ml.enabled":false,"xpack.security.authc.token.enabled":true}` | Add configs to Master nodes |
| elasticsearch.master.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Set securityContext for elasticsearch master node sets |
| elasticsearch.master.containersecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| elasticsearch.master.updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"rollingUpdate"}` | Elasticsearch master updateStrategy |
| elasticsearch.master.volumes | list | `[]` | Elasticsearch master volumes |
| elasticsearch.master.volumeMounts | list | `[]` | Elasticsearch master volumeMounts |
| elasticsearch.master.podAnnotations | object | `{}` | Elasticsearch master podAnnotations |
| elasticsearch.master.affinity | object | `{}` | Elasticsearch master affinity |
| elasticsearch.master.tolerations | list | `[]` | Elasticsearch master tolerations |
| elasticsearch.master.nodeSelector | object | `{}` | Elasticsearch master nodeSelector |
| elasticsearch.master.lifecycle | object | `{}` | Elasticsearch master lifecycle |
| elasticsearch.master.count | int | `3` | Elasticsearch master pod count |
| elasticsearch.master.persistence.storageClassName | string | `""` | Elasticsearch master persistence storageClassName |
| elasticsearch.master.persistence.size | string | `"5Gi"` | Elasticsearch master persistence size |
| elasticsearch.master.resources | object | `{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}}` | Elasticsearch master pod resources |
| elasticsearch.master.heap.min | string | `"2g"` | Elasticsearch master Java heap Xms setting |
| elasticsearch.master.heap.max | string | `"2g"` | Elasticsearch master Java heap Xmx setting |
| elasticsearch.data.initContainers | list | `[]` | Add init containers to data pods |
| elasticsearch.data.config | object | `{"index.store.type":"mmapfs","node.roles":["data","ingest"],"node.store.allow_mmap":true,"xpack.ml.enabled":false,"xpack.security.authc.token.enabled":true}` | Add configs to Data nodes |
| elasticsearch.data.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Set securityContext for elasticsearch data node sets |
| elasticsearch.data.containersecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| elasticsearch.data.volumes | list | `[]` | Elasticsearch data volumes |
| elasticsearch.data.volumeMounts | list | `[]` | Elasticsearch data volumeMounts |
| elasticsearch.data.podAnnotations | object | `{}` | Elasticsearch data podAnnotations |
| elasticsearch.data.affinity | object | `{}` | Elasticsearch data affinity |
| elasticsearch.data.tolerations | list | `[]` | Elasticsearch data tolerations |
| elasticsearch.data.nodeSelector | object | `{}` | Elasticsearch data nodeSelector |
| elasticsearch.data.lifecycle | object | `{}` | Elasticsearch data lifecycle |
| elasticsearch.data.count | int | `4` | Elasticsearch data pod count |
| elasticsearch.data.persistence.storageClassName | string | `""` | Elasticsearch data persistence storageClassName |
| elasticsearch.data.persistence.size | string | `"100Gi"` | Elasticsearch data persistence size |
| elasticsearch.data.resources | object | `{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}}` | Elasticsearch data pod resources |
| elasticsearch.data.heap.min | string | `"2g"` | Elasticsearch data Java heap Xms setting |
| elasticsearch.data.heap.max | string | `"2g"` | Elasticsearch data Java heap Xmx setting |
| elasticsearch.ingest.enabled | bool | `false` | Enable ingest specific Elasticsearch pods |
| elasticsearch.ingest.initContainers | list | `[]` | initContainers |
| elasticsearch.ingest.config | object | `{"index.store.type":"mmapfs","node.roles":["ingest"],"node.store.allow_mmap":true,"xpack.ml.enabled":false,"xpack.security.authc.token.enabled":true}` | Add configs to Ingest Nodes |
| elasticsearch.ingest.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Set securityContext for elasticsearch ingest node sets |
| elasticsearch.ingest.containersecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
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
| elasticsearch.ingest.resources | object | `{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}}` | Elasticsearch ingest pod resources |
| elasticsearch.ingest.heap.min | string | `"2g"` | Xms |
| elasticsearch.ingest.heap.max | string | `"2g"` | Xmx |
| elasticsearch.ml.enabled | bool | `false` | Enable Machine Learning specific Elasticsearch pods If enabled to true then the xpack.ml.enabled should be true for master, data, ingest, ml, coordinating node config below  |
| elasticsearch.ml.initContainers | list | `[]` | initContainers |
| elasticsearch.ml.config | object | `{"index.store.type":"mmapfs","node.roles":["ml"],"node.store.allow_mmap":true,"xpack.ml.enabled":false,"xpack.security.authc.token.enabled":true}` | Add configs to ML Nodes |
| elasticsearch.ml.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Set securityContext for elasticsearch ml node sets |
| elasticsearch.ml.containersecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| elasticsearch.ml.updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"rollingUpdate"}` | Elasticsearch ml updateStrategy |
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
| elasticsearch.ml.resources | object | `{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}}` | Elasticsearch ml pod resources |
| elasticsearch.ml.heap.min | string | `"2g"` | Xms |
| elasticsearch.ml.heap.max | string | `"2g"` | Xmx |
| elasticsearch.coord.enabled | bool | `false` | Enable coordinating specific Elasticsearch pods |
| elasticsearch.coord.initContainers | list | `[]` | initContainers |
| elasticsearch.coord.config | object | `{"index.store.type":"mmapfs","node.store.allow_mmap":true,"xpack.ml.enabled":false,"xpack.security.authc.token.enabled":true}` | Add configs to Coordinating Nodes |
| elasticsearch.coord.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Set securityContext for elasticsearch coordinating node sets |
| elasticsearch.coord.containersecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| elasticsearch.coord.updateStrategy | object | `{"rollingUpdate":{"maxUnavailable":1},"type":"rollingUpdate"}` | Elasticsearch coord updateStrategy |
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
| elasticsearch.coord.resources | object | `{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}}` | Elasticsearch coord pod resources |
| elasticsearch.coord.heap.min | string | `"2g"` | Xms |
| elasticsearch.coord.heap.max | string | `"2g"` | Xmx |
| istio.enabled | bool | `false` | Toggle istio interaction. |
| istio.hardened.enabled | bool | `false` |  |
| istio.hardened.customAuthorizationPolicies | list | `[]` |  |
| istio.hardened.outboundTrafficPolicyMode | string | `"REGISTRY_ONLY"` |  |
| istio.hardened.customServiceEntries | list | `[]` |  |
| istio.hardened.fluentbit.enabled | bool | `true` |  |
| istio.hardened.fluentbit.namespaces[0] | string | `"fluentbit"` |  |
| istio.hardened.fluentbit.principals[0] | string | `"cluster.local/ns/fluentbit/sa/fluentbit-fluent-bit"` |  |
| istio.hardened.elasticOperator.enabled | bool | `true` |  |
| istio.hardened.elasticOperator.namespaces[0] | string | `"eck-operator"` |  |
| istio.hardened.elasticOperator.principals[0] | string | `"cluster.local/ns/eck-operator/sa/elastic-operator"` |  |
| istio.hardened.mattermost.enabled | bool | `true` |  |
| istio.hardened.mattermost.namespaces[0] | string | `"mattermost"` |  |
| istio.hardened.mattermost.principals[0] | string | `"cluster.local/ns/mattermost/sa/mattermost"` |  |
| istio.hardened.jaeger.enabled | bool | `true` |  |
| istio.hardened.jaeger.namespaces[0] | string | `"jaeger"` |  |
| istio.hardened.jaeger.principals[0] | string | `"cluster.local/ns/jaeger/sa/default"` |  |
| istio.hardened.jaeger.principals[1] | string | `"cluster.local/ns/jaeger/sa/jaeger"` |  |
| istio.hardened.jaeger.principals[2] | string | `"cluster.local/ns/jaeger/sa/jaeger-instance"` |  |
| istio.hardened.elasticsearch.enabled | bool | `true` |  |
| istio.hardened.elasticsearch.namespaces[0] | string | `"logging"` |  |
| istio.hardened.elasticsearch.principals[0] | string | `"cluster.local/ns/logging/sa/logging-elasticsearch"` |  |
| istio.mtls | object | `{"mode":"STRICT"}` | Default EK peer authentication       |
| istio.mtls.mode | string | `"STRICT"` | STRICT = Allow only mutual TLS traffic, PERMISSIVE = Allow both plain text and mutual TLS traffic |
| istio.elasticsearch.enabled | bool | `false` | Toggle virtualService creation |
| istio.elasticsearch.annotations | object | `{}` | Annotations for controls the gateway used/attached to the virtualService |
| istio.elasticsearch.labels | object | `{}` | Labels for virtualService |
| istio.elasticsearch.gateways | list | `["istio-system/main"]` | Gateway(s) to apply virtualService routes to. |
| istio.elasticsearch.hosts | list | `["elasticsearch.{{ .Values.domain }}"]` | hosts for the virtualService |
| istio.kibana.enabled | bool | `true` | Toggle virtualService creation |
| istio.kibana.annotations | object | `{}` | Annotations for controls the gateway used/attached to the virtualService |
| istio.kibana.labels | object | `{}` | Labels for virtualService |
| istio.kibana.gateways | list | `["istio-system/main"]` | Gateway(s) to apply virtualService routes to. |
| istio.kibana.hosts | list | `["kibana.{{ .Values.domain }}"]` | hosts for the virtualService |
| sso.enabled | bool | `false` | Toggle SSO with Keycloak |
| sso.redirect_url | string | `""` | redirect_url defaults to .Values.istio.kibana.hosts[0] if not set. |
| sso.client_id | string | `"platform1_a8604cc9-f5e9-4656-802d-d05624370245_bb8-kibana"` | client_id |
| sso.client_secret | string | `""` | OIDC client secret, can be empty for public client. |
| sso.oidc.host | string | `"login.dso.mil"` | host |
| sso.oidc.realm | string | `"baby-yoda"` | realm |
| sso.issuer | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}"` | issuer |
| sso.auth_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/auth"` | auth_url |
| sso.token_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/token"` | token_url |
| sso.userinfo_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/userinfo"` | userinfo_url |
| sso.jwkset_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/certs"` | jwks_url |
| sso.claims_principal | string | `"preferred_username"` | claims_principal |
| sso.requested_scopes | list | `["openid"]` | requested_scopes |
| sso.signature_algorithm | string | `"RS256"` | signature_algorithm |
| sso.endsession_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/logout"` | endsession_url |
| sso.claims_group | string | `"groups"` | claims_group |
| sso.claims_mail | string | `"email"` | claims_mail |
| sso.claims_principal_pattern | string | `""` | claims_principal_pattern |
| sso.cert_authorities | list | `[]` | cert_authorities |
| kibanaBasicAuth.enabled | bool | `true` | Toggle this to turn off Kibana's built in auth and only allow SSO. Role mappings for SSO groups must be set up and SSO enabled before doing this. |
| networkPolicies.enabled | bool | `false` | Toggle BigBang NetworkPolicy templates |
| networkPolicies.ingressLabels | object | `{"app":"istio-ingressgateway","istio":"ingressgateway"}` | Istio Ingressgateway labels. passed down to NetworkPolicy to whitelist external access to app |
| networkPolicies.controlPlaneCidr | string | `"0.0.0.0/0"` | See `kubectl cluster-info` and then resolve to IP |
| networkPolicies.additionalPolicies | list | `[]` |  |
| upgradeJob.image.repository | string | `"registry1.dso.mil/ironbank/big-bang/base"` | image repository for upgradeJob |
| upgradeJob.image.tag | string | `"2.1.0"` | image tag for upgradeJob |
| monitoring.enabled | bool | `false` | Toggle BigBang monitoring integration, controls serviceMonitor template |
| metrics.enabled | bool | `false` | Toggle Prometheus ElasticSearch Exporter Installation |
| metrics.global | object | `{"imagePullSecrets":[]}` | Exporter imagePullSecrets |
| metrics.image.registry | string | `"registry1.dso.mil"` |  |
| metrics.image.repository | string | `"ironbank/opensource/bitnami/elasticsearch-exporter"` |  |
| metrics.image.tag | string | `"1.9.0"` |  |
| metrics.image.pullSecret | string | `"private-registry"` |  |
| metrics.podSecurityContext | object | `{"runAsGroup":1000}` | Pod securityContext |
| metrics.securityContext | object | `{"runAsGroup":1000,"runAsUser":1000}` | Container securityContext |
| metrics.serviceMonitor.scheme | string | `""` |  |
| metrics.serviceMonitor.tlsConfig | object | `{}` |  |
| metrics.env | object | `{"ES_USERNAME":"elastic"}` | Environment Variable Passthrough to set Auth for Exporter |
| metrics.extraEnvSecrets | object | `{"ES_PASSWORD":{"key":"elastic","secret":"logging-ek-es-elastic-user"}}` | Environment Variable Secret Mount to set Auth for Exporter Replace with empty braces if you would like to use a an API_KEY |
| dashboards.enabled | bool | `true` |  |
| dashboards.namespace | string | `"monitoring"` |  |
| dashboards.labels.grafana_dashboard | string | `"1"` |  |
| openshift | bool | `false` | Openshift Container Platform Feature Toggle |
| mattermost.enabled | bool | `false` | Mattermost integration toggle, controls mTLS exception and networkPolicies |
| bbtests.enabled | bool | `false` | Big Bang CI/Dev toggle for helm tests |
| bbtests.cypress.artifacts | bool | `true` | Toggle creation of cypress artifacts |
| bbtests.cypress.envs | object | `{"cypress_expect_logs":"false","cypress_kibana_url":"https://logging-ek-kb-http:5601"}` | ENVs added to cypress test pods |
| bbtests.cypress.secretEnvs | list | `[{"name":"cypress_elastic_password","valueFrom":{"secretKeyRef":{"key":"elastic","name":"logging-ek-es-elastic-user"}}}]` | ENVs added to cypress test pods from existing secrets |
| bbtests.scripts.image | string | `"registry1.dso.mil/ironbank/big-bang/base:2.1.0"` | image to use for script based tests |
| bbtests.scripts.envs | object | `{"desired_version":"{{ .Values.elasticsearch.version }}","elasticsearch_host":"https://{{ .Release.Name }}-es-http.{{ .Release.Namespace }}.svc.cluster.local:9200"}` | ENVs added to script test pods |
| bbtests.scripts.secretEnvs | list | `[{"name":"ELASTIC_PASSWORD","valueFrom":{"secretKeyRef":{"key":"elastic","name":"logging-ek-es-elastic-user"}}}]` | ENVs added to script test pods from existing secrets |
| waitJob.enabled | bool | `true` |  |
| waitJob.scripts.image | string | `"registry1.dso.mil/ironbank/opensource/kubernetes/kubectl:v1.33.5"` |  |
| waitJob.permissions.resources[0] | string | `"elasticsearch-kibana"` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.

---

_This file is programatically generated using `helm-docs` and some BigBang-specific templates. The `gluon` repository has [instructions for regenerating package READMEs](https://repo1.dso.mil/big-bang/product/packages/gluon/-/blob/master/docs/bb-package-readme.md)._


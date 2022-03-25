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
| autoRollingUpgrade | object | `{"enabled":true}` | Enable BigBang specific autoRollingUpgrade support, more information in package README.md. |
| imagePullPolicy | string | `"IfNotPresent"` | Pull Policy for all non-init containers in this package. |
| kibana.version | string | `"7.17.1"` |  |
| kibana.image.repository | string | `"registry1.dso.mil/ironbank/elastic/kibana/kibana"` |  |
| kibana.image.tag | string | `"7.17.1"` |  |
| kibana.host | string | `""` | Only required if not using Istio for ingress. |
| kibana.count | int | `3` | Number of Kibana replicas |
| kibana.serviceAccountName | string | `"logging-kibana"` | Name for serviceAccount to use, will be autocreated. |
| kibana.updateStrategy.type | string | `"rollingUpdate"` |  |
| kibana.updateStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| kibana.securityContext.runAsUser | int | `1000` |  |
| kibana.securityContext.runAsGroup | int | `1000` |  |
| kibana.securityContext.fsGroup | int | `1000` |  |
| kibana.imagePullSecrets | list | `[]` |  |
| kibana.resources.requests.memory | string | `"2Gi"` |  |
| kibana.resources.requests.cpu | int | `1` |  |
| kibana.resources.limits.memory | string | `"2Gi"` |  |
| kibana.resources.limits.cpu | int | `1` |  |
| kibana.volumes | list | `[]` |  |
| kibana.volumeMounts | list | `[]` |  |
| kibana.podAnnotations | object | `{}` |  |
| kibana.affinity | object | `{}` |  |
| kibana.tolerations | list | `[]` |  |
| kibana.nodeSelector | object | `{}` |  |
| kibana.lifecycle | object | `{}` |  |
| elasticsearch.version | string | `"7.17.1"` |  |
| elasticsearch.image.repository | string | `"registry1.dso.mil/ironbank/elastic/elasticsearch/elasticsearch"` |  |
| elasticsearch.image.tag | string | `"7.17.1"` |  |
| elasticsearch.imagePullSecrets | list | `[]` |  |
| elasticsearch.serviceAccountName | string | `"logging-elasticsearch"` | Name for serviceAccount to use, will be autocreated. |
| elasticsearch.master | object | `{"affinity":{},"count":3,"heap":{"max":"2g","min":"2g"},"initContainers":[],"lifecycle":{},"nodeSelector":{},"persistence":{"size":"5Gi","storageClassName":""},"podAnnotations":{},"resources":{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}},"securityContext":{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000},"tolerations":[],"updateStrategy":{"rollingUpdate":{"maxUnavailable":1},"type":"rollingUpdate"},"volumeMounts":[],"volumes":[]}` | Values for master node sets. |
| elasticsearch.master.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Add ability customize the security context for fixing user or group. |
| elasticsearch.data | object | `{"affinity":{},"count":4,"heap":{"max":"2g","min":"2g"},"initContainers":[],"lifecycle":{},"nodeSelector":{},"persistence":{"size":"100Gi","storageClassName":""},"podAnnotations":{},"resources":{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}},"securityContext":{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000},"tolerations":[],"volumeMounts":[],"volumes":[]}` | Values for data node sets. |
| elasticsearch.data.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Add ability customize the security context for fixing user or group. |
| elasticsearch.ingest | object | `{"affinity":{},"count":1,"enabled":false,"heap":{"max":"2g","min":"2g"},"initContainers":[],"lifecycle":{},"nodeSelector":{},"persistence":{"size":"100Gi","storageClassName":""},"podAnnotations":{},"resources":{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}},"securityContext":{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000},"tolerations":[],"volumeMounts":[],"volumes":[]}` | Values for ingest node sets. |
| elasticsearch.ingest.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Add ability customize the security context for fixing user or group. |
| elasticsearch.ml | object | `{"affinity":{},"count":1,"enabled":false,"heap":{"max":"2g","min":"2g"},"initContainers":[],"lifecycle":{},"nodeSelector":{},"persistence":{"size":"100Gi","storageClassName":""},"podAnnotations":{},"resources":{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}},"securityContext":{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000},"tolerations":[],"updateStrategy":{"rollingUpdate":{"maxUnavailable":1},"type":"rollingUpdate"},"volumeMounts":[],"volumes":[]}` | Values for data node sets. |
| elasticsearch.ml.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Add ability customize the security context for fixing user or group. |
| elasticsearch.coord | object | `{"affinity":{},"count":1,"enabled":false,"heap":{"max":"2g","min":"2g"},"initContainers":[],"lifecycle":{},"nodeSelector":{},"persistence":{"size":"100Gi","storageClassName":""},"podAnnotations":{},"resources":{"limits":{"cpu":1,"memory":"4Gi"},"requests":{"cpu":1,"memory":"4Gi"}},"securityContext":{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000},"tolerations":[],"updateStrategy":{"rollingUpdate":{"maxUnavailable":1},"type":"rollingUpdate"},"volumeMounts":[],"volumes":[]}` | Values for coordinating node sets. |
| elasticsearch.coord.securityContext | object | `{"fsGroup":1000,"runAsGroup":1000,"runAsUser":1000}` | Add ability customize the security context for fixing user or group. |
| istio.enabled | bool | `false` | Toggle istio interaction. |
| istio.kibana.enabled | bool | `true` | Toggle vs creation |
| istio.kibana.annotations | object | `{}` |  |
| istio.kibana.labels | object | `{}` |  |
| istio.kibana.gateways[0] | string | `"istio-system/main"` |  |
| istio.kibana.hosts[0] | string | `"kibana.{{ .Values.hostname }}"` |  |
| sso | object | `{"auth_url":"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/auth","cert_authorities":[],"claims_group":"groups","claims_mail":"email","claims_principal":"preferred_username","claims_principal_pattern":"","client_id":"platform1_a8604cc9-f5e9-4656-802d-d05624370245_bb8-kibana","client_secret":"","enabled":false,"endsession_url":"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/logout","issuer":"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}","jwkset_url":"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/certs","oidc":{"host":"login.dso.mil","realm":"baby-yoda"},"redirect_url":"","requested_scopes":["openid"],"signature_algorithm":"RS256","token_url":"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/token","userinfo_url":"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/userinfo"}` | Example values are for local development. |
| sso.redirect_url | string | `""` | redirect_url defaults to .Values.istio.kibana.hosts[0] if not set |
| sso.client_secret | string | `""` | OIDC client secret, can be empty for public client |
| sso.issuer | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}"` | additional fields (required for SSO - default templates for keycloak) |
| sso.signature_algorithm | string | `"RS256"` | Additional fields (required for keycloak - may be optional for other providers). |
| sso.claims_principal_pattern | string | `""` | Additional fields. |
| kibanaBasicAuth | object | `{"enabled":true}` | Role mappings for SSO groups must be set up and SSO enabled before doing this. |
| networkPolicies.enabled | bool | `false` |  |
| networkPolicies.ingressLabels.app | string | `"istio-ingressgateway"` |  |
| networkPolicies.ingressLabels.istio | string | `"ingressgateway"` |  |
| networkPolicies.controlPlaneCidr | string | `"0.0.0.0/0"` | See `kubectl cluster-info` and then resolve to IP |
| upgradeJob.image.repository | string | `"registry1.dso.mil/ironbank/big-bang/base"` |  |
| upgradeJob.image.tag | float | `8.4` |  |
| openshift | bool | `false` |  |
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

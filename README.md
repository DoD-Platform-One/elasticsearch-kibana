# logging

![Version: 0.5.0-bb.0](https://img.shields.io/badge/Version-0.5.0--bb.0-informational?style=flat-square) ![AppVersion: 7.16.1](https://img.shields.io/badge/AppVersion-7.16.1-informational?style=flat-square)

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
| autoRollingUpgrade | object | `{"enabled":true}` | Enable BigBang specific autoRollingUpgrade support, more info in package README.md. |
| imagePullPolicy | string | `"IfNotPresent"` |  |
| kibana.version | string | `"7.16.1"` |  |
| kibana.image.repository | string | `"registry1.dso.mil/ironbank/elastic/kibana/kibana"` |  |
| kibana.image.tag | string | `"7.16.1"` |  |
| kibana.host | string | `""` |  |
| kibana.count | int | `3` |  |
| kibana.serviceAccountName | string | `"logging-kibana"` |  |
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
| elasticsearch.version | string | `"7.16.1"` |  |
| elasticsearch.image.repository | string | `"registry1.dso.mil/ironbank/elastic/elasticsearch/elasticsearch"` |  |
| elasticsearch.image.tag | string | `"7.16.1"` |  |
| elasticsearch.imagePullSecrets | list | `[]` |  |
| elasticsearch.serviceAccountName | string | `"logging-elasticsearch"` |  |
| elasticsearch.master.initContainers | list | `[]` |  |
| elasticsearch.master.securityContext.runAsUser | int | `1000` |  |
| elasticsearch.master.securityContext.runAsGroup | int | `1000` |  |
| elasticsearch.master.securityContext.fsGroup | int | `1000` |  |
| elasticsearch.master.updateStrategy.type | string | `"rollingUpdate"` |  |
| elasticsearch.master.updateStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| elasticsearch.master.volumes | list | `[]` |  |
| elasticsearch.master.volumeMounts | list | `[]` |  |
| elasticsearch.master.podAnnotations | object | `{}` |  |
| elasticsearch.master.affinity | object | `{}` |  |
| elasticsearch.master.tolerations | list | `[]` |  |
| elasticsearch.master.nodeSelector | object | `{}` |  |
| elasticsearch.master.lifecycle | object | `{}` |  |
| elasticsearch.master.count | int | `3` |  |
| elasticsearch.master.persistence.storageClassName | string | `""` |  |
| elasticsearch.master.persistence.size | string | `"5Gi"` |  |
| elasticsearch.master.resources.limits.cpu | int | `1` |  |
| elasticsearch.master.resources.limits.memory | string | `"4Gi"` |  |
| elasticsearch.master.resources.requests.cpu | int | `1` |  |
| elasticsearch.master.resources.requests.memory | string | `"4Gi"` |  |
| elasticsearch.master.heap.min | string | `"2g"` |  |
| elasticsearch.master.heap.max | string | `"2g"` |  |
| elasticsearch.data.initContainers | list | `[]` |  |
| elasticsearch.data.securityContext.runAsUser | int | `1000` |  |
| elasticsearch.data.securityContext.runAsGroup | int | `1000` |  |
| elasticsearch.data.securityContext.fsGroup | int | `1000` |  |
| elasticsearch.data.volumes | list | `[]` |  |
| elasticsearch.data.volumeMounts | list | `[]` |  |
| elasticsearch.data.podAnnotations | object | `{}` |  |
| elasticsearch.data.affinity | object | `{}` |  |
| elasticsearch.data.tolerations | list | `[]` |  |
| elasticsearch.data.nodeSelector | object | `{}` |  |
| elasticsearch.data.lifecycle | object | `{}` |  |
| elasticsearch.data.count | int | `4` |  |
| elasticsearch.data.persistence.storageClassName | string | `""` |  |
| elasticsearch.data.persistence.size | string | `"100Gi"` |  |
| elasticsearch.data.resources.limits.cpu | int | `1` |  |
| elasticsearch.data.resources.limits.memory | string | `"4Gi"` |  |
| elasticsearch.data.resources.requests.cpu | int | `1` |  |
| elasticsearch.data.resources.requests.memory | string | `"4Gi"` |  |
| elasticsearch.data.heap.min | string | `"2g"` |  |
| elasticsearch.data.heap.max | string | `"2g"` |  |
| elasticsearch.ingest.enabled | bool | `false` |  |
| elasticsearch.ingest.initContainers | list | `[]` |  |
| elasticsearch.ingest.securityContext.runAsUser | int | `1000` |  |
| elasticsearch.ingest.securityContext.runAsGroup | int | `1000` |  |
| elasticsearch.ingest.securityContext.fsGroup | int | `1000` |  |
| elasticsearch.ingest.volumes | list | `[]` |  |
| elasticsearch.ingest.volumeMounts | list | `[]` |  |
| elasticsearch.ingest.podAnnotations | object | `{}` |  |
| elasticsearch.ingest.affinity | object | `{}` |  |
| elasticsearch.ingest.tolerations | list | `[]` |  |
| elasticsearch.ingest.nodeSelector | object | `{}` |  |
| elasticsearch.ingest.lifecycle | object | `{}` |  |
| elasticsearch.ingest.count | int | `1` |  |
| elasticsearch.ingest.persistence.storageClassName | string | `""` |  |
| elasticsearch.ingest.persistence.size | string | `"100Gi"` |  |
| elasticsearch.ingest.resources.limits.cpu | int | `1` |  |
| elasticsearch.ingest.resources.limits.memory | string | `"4Gi"` |  |
| elasticsearch.ingest.resources.requests.cpu | int | `1` |  |
| elasticsearch.ingest.resources.requests.memory | string | `"4Gi"` |  |
| elasticsearch.ingest.heap.min | string | `"2g"` |  |
| elasticsearch.ingest.heap.max | string | `"2g"` |  |
| elasticsearch.ml.enabled | bool | `false` |  |
| elasticsearch.ml.initContainers | list | `[]` |  |
| elasticsearch.ml.securityContext.runAsUser | int | `1000` |  |
| elasticsearch.ml.securityContext.runAsGroup | int | `1000` |  |
| elasticsearch.ml.securityContext.fsGroup | int | `1000` |  |
| elasticsearch.ml.updateStrategy.type | string | `"rollingUpdate"` |  |
| elasticsearch.ml.updateStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| elasticsearch.ml.volumes | list | `[]` |  |
| elasticsearch.ml.volumeMounts | list | `[]` |  |
| elasticsearch.ml.podAnnotations | object | `{}` |  |
| elasticsearch.ml.affinity | object | `{}` |  |
| elasticsearch.ml.tolerations | list | `[]` |  |
| elasticsearch.ml.nodeSelector | object | `{}` |  |
| elasticsearch.ml.lifecycle | object | `{}` |  |
| elasticsearch.ml.count | int | `1` |  |
| elasticsearch.ml.persistence.storageClassName | string | `""` |  |
| elasticsearch.ml.persistence.size | string | `"100Gi"` |  |
| elasticsearch.ml.resources.limits.cpu | int | `1` |  |
| elasticsearch.ml.resources.limits.memory | string | `"4Gi"` |  |
| elasticsearch.ml.resources.requests.cpu | int | `1` |  |
| elasticsearch.ml.resources.requests.memory | string | `"4Gi"` |  |
| elasticsearch.ml.heap.min | string | `"2g"` |  |
| elasticsearch.ml.heap.max | string | `"2g"` |  |
| elasticsearch.coord.enabled | bool | `false` |  |
| elasticsearch.coord.initContainers | list | `[]` |  |
| elasticsearch.coord.securityContext.runAsUser | int | `1000` |  |
| elasticsearch.coord.securityContext.runAsGroup | int | `1000` |  |
| elasticsearch.coord.securityContext.fsGroup | int | `1000` |  |
| elasticsearch.coord.updateStrategy.type | string | `"rollingUpdate"` |  |
| elasticsearch.coord.updateStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| elasticsearch.coord.volumes | list | `[]` |  |
| elasticsearch.coord.volumeMounts | list | `[]` |  |
| elasticsearch.coord.podAnnotations | object | `{}` |  |
| elasticsearch.coord.affinity | object | `{}` |  |
| elasticsearch.coord.tolerations | list | `[]` |  |
| elasticsearch.coord.nodeSelector | object | `{}` |  |
| elasticsearch.coord.lifecycle | object | `{}` |  |
| elasticsearch.coord.count | int | `1` |  |
| elasticsearch.coord.persistence.storageClassName | string | `""` |  |
| elasticsearch.coord.persistence.size | string | `"100Gi"` |  |
| elasticsearch.coord.resources.limits.cpu | int | `1` |  |
| elasticsearch.coord.resources.limits.memory | string | `"4Gi"` |  |
| elasticsearch.coord.resources.requests.cpu | int | `1` |  |
| elasticsearch.coord.resources.requests.memory | string | `"4Gi"` |  |
| elasticsearch.coord.heap.min | string | `"2g"` |  |
| elasticsearch.coord.heap.max | string | `"2g"` |  |
| istio.enabled | bool | `false` |  |
| istio.kibana.enabled | bool | `true` |  |
| istio.kibana.annotations | object | `{}` |  |
| istio.kibana.labels | object | `{}` |  |
| istio.kibana.gateways[0] | string | `"istio-system/main"` |  |
| istio.kibana.hosts[0] | string | `"kibana.{{ .Values.hostname }}"` |  |
| sso.enabled | bool | `false` |  |
| sso.redirect_url | string | `""` |  |
| sso.client_id | string | `"platform1_a8604cc9-f5e9-4656-802d-d05624370245_bb8-kibana"` |  |
| sso.client_secret | string | `""` | OIDC client secret, can be empty for public client |
| sso.oidc.host | string | `"login.dso.mil"` |  |
| sso.oidc.realm | string | `"baby-yoda"` |  |
| sso.issuer | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}"` |  |
| sso.auth_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/auth"` |  |
| sso.token_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/token"` |  |
| sso.userinfo_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/userinfo"` |  |
| sso.jwkset_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/certs"` |  |
| sso.claims_principal | string | `"preferred_username"` |  |
| sso.requested_scopes[0] | string | `"openid"` |  |
| sso.signature_algorithm | string | `"RS256"` |  |
| sso.endsession_url | string | `"https://{{ .Values.sso.oidc.host }}/auth/realms/{{ .Values.sso.oidc.realm }}/protocol/openid-connect/logout"` |  |
| sso.claims_group | string | `"groups"` |  |
| sso.claims_mail | string | `"email"` |  |
| sso.claims_principal_pattern | string | `""` |  |
| sso.cert_authorities | list | `[]` |  |
| kibanaBasicAuth.enabled | bool | `true` |  |
| networkPolicies.enabled | bool | `false` |  |
| networkPolicies.ingressLabels.app | string | `"istio-ingressgateway"` |  |
| networkPolicies.ingressLabels.istio | string | `"ingressgateway"` |  |
| networkPolicies.controlPlaneCidr | string | `"0.0.0.0/0"` |  |
| upgradeJob.image.repository | string | `"registry1.dso.mil/ironbank/big-bang/base"` |  |
| upgradeJob.image.tag | float | `8.4` |  |
| openshift | bool | `false` |  |

## Contributing

Please see the [contributing guide](./CONTRIBUTING.md) if you are interested in contributing.

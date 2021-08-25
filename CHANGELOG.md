# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
## [0.1.20-bb.0] - 2021-08-24
### Changed
- Handling of ml enabled nodes and values.
### Added
- Adding values and support for the following types of nodeSets:
  - ingest
  - coordinating
  - machine learning (ml)

## [0.1.19-bb.1] - 2021-08-23
### Changed
- Increased heap values to be half the size of Resources

## [0.1.19-bb.0] - 2021-08-23
### Changed
- Changed node.ml and xpack.ml.enabled config values in elasticsearch.yaml to helm template directives
### Added
- Added default values for node.ml and xpack.ml.enabled set to false in top level values.yaml

## [0.1.18-bb.1] - 2021-08-15
### Added
- Added resource requests and limits to upgrade-job

## [0.1.18-bb.0] - 2021-08-09
### Changed
- upgrade-job template syntax and support for 7.12 > 7.13 Elasticsearch upgrades
- Update Elasticsearch to version 7.13.4 to address ESA-2021-16

## [0.1.17-bb.2] - 2021-08-09
### Added
- Resource limits and requests.

## [0.1.17-bb.1] - 2021-07-23
### Added
- Add openshift toggle. If it's set, add port 5353 egress rule.

## [0.1.17-bb.0] - 2021-07-19
### Changed
- Modified upgradeJob image from gitlab/kubectl:13.9.0 to big-bang/base:8.4 

## [0.1.16-bb.0] - 2021-07-12
### Changed
- Switched to usage of non-default service account for all created pods
### Added
- Serviceaccounts are created by the chart, one for elastic one for kibana
- Serviceaccount names can be set via values `kibana.serviceAccountName` and `elasticsearch.serviceAccountName`

## [0.1.15-bb.1] - 2021-07-02
### Added
- Network policy to allow prometheus scraping of istio envoy sidecar.

## [0.1.15-bb.0] - 2021-06-22
### Changed
- Upgrade to version 7.12.0 of Kibana and Elasticsearch
- Tweaks to autoRollingUpgrade job to allow for transition from 7.10 to 7.12 .

## [0.1.14-bb.1] - 2021-06-17
### Added
- Network Policy templates.
  - In Namespace allow to Elasticsearch
  - Wide open Egress for SSO when SSO is enabled
### Changed
- Network Policy Template fixes.
  - Syntax fix on podSelector in istio specific Network Policy.

## [0.1.14-bb.0] - 2021-06-08
### Added
- UpgradeJob image. Allow for overrides

## [0.1.13-bb.0] - 2021-06-04
### Added
- Network Policy templates. Allow ingress from mattermost to elasticsearch

## [0.1.12-bb.0] - 2021-06-03
### Added
- Network Policy templates. Allow cluster ingress, egress to kube-dns, istiod, ingress from istio-ingressgateway, and ingress from jager pods & eck-operator pods.

## [0.1.11-bb.0] - 2021-05-17
### Changed
- Updating Kibana and Elasticsearch versions to 7.10
### Added
- autoRollingUpgrade job, value toggle, and Documentation along with Troubleshooting ECK upgrades.

## [0.1.10-bb.2] - 2021-05-14
### Added
- Bug and stability fix for 0.1.10-bb.0 tag

## [0.1.10-bb.1] - 2021-05-14
### Added
- ensure kibana nodeSelector and affinity are properly indended, add whitespace removal to nodeSelector and affinity

## [0.1.10-bb.0] - 2021-05-11
### Added
- Moved elasticsearch oidc realm definition into a helper function
- Exposed default keycloak values as fields which can be overridden
- Added pod annotations to force ES restarts in the event the `sso-secret` or oidc realm definition change
- Added support for specifying `sso.certificate_authorities`

## [0.1.9-bb.0] - 2021-04-19
### Added
- Adding volume and volumeMounts declaration support for Kibana and Elasticsearch resources

## [0.1.8-bb.0] - 2021-04-19
### Added
- Adding Lifecycle declaration support for Kibana and Elasticsearch resources

## [0.1.7-bb.0] - 2021-04-07
### Added
- Updating isito labels for elasticsearch resource

## [0.1.6-bb.0] - 2021-03-30
### Added
- `kibana.count` to chart values
### Changed
- modified the values for affinity and nodeSelector to allow greater flexibility

## [0.1.5-bb.0] - 2021-03-05

### Added
- kibana.securityContext to chart values.
- securityContext block to Kibana custom resource template.

## [0.1.4-bb.4] - 2021-03-02

### Changed
- Added default value for xpack.security.authc.realms.oidc.{{ .Values.sso.oidc.realm }}.rp.client_secret in sso-secret template to not error out when not populated.

## [0.1.4-bb.3] - 2021-01-27

### Added
- elasticsearch.data.securityContext to chart values.
- elasticsearch.master.securityContext to chart values.
- securityContext blocks to elasticsearch custom resource templates.

## [0.1.4-bb.2] - 2021-02-09

### Added

- Adds the ability to create pod antiaffinity and node affinity.
- Adds the ability to add labels, annotations, a list of gateways and hosts for the kibana virtualservice.

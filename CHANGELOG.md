# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
## [1.27.0-bb.0] (2025-03-05)
### Changed
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.17.2 to 8.17.3
- ironbank/elastic/kibana/kibana updated from 8.17.2 to 8.17.3
- prometheus-elasticsearch-exporter helm chart updated from 6.6.0 to 6.6.1
- ironbank/opensource/kubernetes/kubectl updated from v1.30.9 to v1.30.10

## [1.26.0-bb.0] - 2025-02-12
### Changed
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.17.1 to 8.17.2
- ironbank/elastic/kibana/kibana updated from 8.17.1 to 8.17.2

## [1.25.0-bb.0] - 2025-01-22
### Changed
- gluon updated from 0.5.12 to 0.5.14
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.17.0 to 8.17.1
- ironbank/elastic/kibana/kibana updated from 8.17.0 to 8.17.1
- ironbank/opensource/kubernetes/kubectl updated from v1.30.8 to v1.30.9
- update kibana init container name from eks-operator 2.16.1 update: https://github.com/elastic/cloud-on-k8s/issues/8426

## [1.24.0-bb.2] - 2024-12-23
### Changed

- Updated pod templates to include common kubernetes labels
- Rolled back podLabels added as part of 1.18.0-bb.1
- prometheus-elasticsearch-exporter to 6.6.0

## [1.24.0-bb.1] - 2024-12-16
### Changed
- added the ability to add custom authorizationPolicies
- added helm unittest tests

## [1.24.0-bb.0] - 2024-12-13
### Changed
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.16.1 to 8.17.0
- ironbank/elastic/kibana/kibana updated from 8.16.1 to 8.17.0
- ironbank/opensource/kubernetes/kubectl updated from v1.30.7 to v1.30.8

## [1.23.0-bb.0] - 2024-11-26
### Changed
- gluon updated from 0.5.10 to 0.5.12
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.16.0 to 8.16.1
- ironbank/elastic/kibana/kibana updated from 8.16.0 to 8.16.1
- ironbank/opensource/kubernetes/kubectl updated from v1.30.6 to v1.30.7

## [1.22.0-bb.0] - 2024-11-13
### Changed
- gluon updated from 0.5.8 to 0.5.10
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.15.3 to 8.16.0
- ironbank/elastic/kibana/kibana updated from 8.15.3 to 8.16.0
- Added the maintenance track annotation and badge

## [1.21.0-bb.0] - 2024-10-25

### Changed

- gluon updated from 0.5.4 to 0.5.8
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.15.2 to 8.15.3
- ironbank/elastic/kibana/kibana updated from 8.15.2 to 8.15.3
- ironbank/opensource/kubernetes/kubectl updated from v1.30.5 to v1.30.6
  
## [1.20.0-bb.1] - 2024-10-25

### Changed

- Moved upgrade job into a separate directory in the bigbang folder

## [1.20.0-bb.0] - 2024-10-17

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.15.1 to 8.15.2
- ironbank/elastic/kibana/kibana updated from 8.15.1 to 8.15.2
- ironbank/opensource/bitnami/elasticsearch-exporter updated from 1.7.0 to 1.8.0
- prometheus-elasticsearch-exporter to 6.5.0
- Added an upgrade job to manually delete the prometheus-elasticsearch-exporter deployment as part of upgrade

## [1.19.0-bb.4] - 2024-10-22

### Changed

- Update podeTemplate to include podLabels
- Update the elasticsearch resource with the chart label

## [1.19.0-bb.3] - 2024-10-11

### Changed

- Configured istio `DestinationRule` to allow envoy to accept certs presented by ElasticSearch
- Updated Kibana config to use `http` scheme when communicating with istio-enabled ElasticSearch

## [1.19.0-bb.2] - 2024-09-30

### Removed

- The auto rolling upgrade job has been removed entirely. The ECK operator (which this package depends on)
  already performs rolling upgrades for elastic and kibana version changes which was all the upgrade job
  tried to do. Also, the upgrade job has been nonfunctional with Kyverno policies enabled for some time.

  [Here](https://github.com/elastic/cloud-on-k8s/blob/7323879c77aecede9971cee8a4b4988906725d7b/docs/orchestrating-elastic-stack-applications/elasticsearch/orchestration.asciidoc#upgrading-the-cluster)
  are the relevant docs from the ECK operator project outlining the operator's upgrade logic.

## [1.19.0-bb.1] - 2024-09-26

### Changed

- Now setting `securityContext` on rolling upgrade `Job` to comply with Kyverno policies

## [1.19.0-bb.0] - 2024-09-26

### Changed

Updated ElasticSearch-Kibana to 1.19.0:

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.14.3 to 8.15.1

  Upstream Release Notes:

  - [8.15.1](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/release-notes-8.15.1.html)
  - [8.15.0](https://www.elastic.co/guide/en/elasticsearch/reference/8.15/release-notes-8.15.0.html)

- ironbank/elastic/kibana/kibana updated from 8.14.3 to 8.15.1

  Upstream Release Notes:

  - [8.15.1](https://www.elastic.co/guide/en/kibana/8.15/release-notes-8.15.1.html)
  - [8.15.0](https://www.elastic.co/guide/en/kibana/8.15/release-notes-8.15.0.html)

- ironbank/opensource/kubernetes/kubectl updated from v1.29.6 to v1.30.5

## [1.18.0-bb.5] - 2024-09-25

### Changed

- Reverted changes made from 1.18.0-bb.3
  - Renabled Elasticsearch selfSignedCertificate
  - Changed mtls to SIMPLE in the Destination Rule
  - Disable Elasticsearch virtual service by default

## [1.18.0-bb.4] - 2024-09-17

### Added

- Gluon post-install wait scripts

## [1.18.0-bb.3] - 2024-09-16

### Changed

- Disabled Elasticsearch selfSignedCertificate if Istio is enabled
- Enforced mtls in the Destination Rule if Istio is enabled
- Enable Elasticsearch virtual service by default

## [1.18.0-bb.2] - 2024-08-29

### Changed

- Fix bug in prometheus subchart that errored when trying to parse podLabels
- Ran a fresh helm dependency update to sync the subchart archive to the copy in deps

## [1.18.0-bb.1] - 2024-08-13

### Changed

- Adds the ability to supply the kiali-required labels app and version via the umbrella chart.

## [1.18.0-bb.0] - 2024-08-02

### Changed

- gluon updated from 0.5.0 to 0.5.2
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.14.1 to 8.14.3
- ironbank/elastic/kibana/kibana updated from 8.14.1 to 8.14.3

## [1.17.0-bb.4] - 2024-07-26

### Changed

- Add `elasticsearch.podDisruptionBudget` to `values.yaml`

## [1.17.0-bb.3] - 2024-07-08

### Changed

- Fix the kibana-default peerAuthentication matchLabels selector

## [1.17.0-bb.2] - 2024-07-06

### Added

- Added service account annotations for elasticsearch and kibana

## [1.17.0-bb.1] - 2024-07-02

### Removed

- Removed shared authPolicies set at the Istio level

## [1.17.0-bb.0] - 2024-06-25

### Changed

- Update prometheus-elasticsearch-exporter from 5.7.0 to 5.8.1
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.14.0 to 8.14.1
- ironbank/elastic/kibana/kibana updated from 8.14.0 to 8.14.1

## [1.16.0-bb.0] - 2024-06-06

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.13.4 to 8.14.0
- ironbank/elastic/kibana/kibana updated from 8.13.4 to 8.14.0

## [1.15.0-bb.0] - 2024-05-14

### Changed

- gluon updated from 0.4.10 to 0.5.0
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.13.2 to 8.13.4
- ironbank/elastic/kibana/kibana updated from 8.13.2 to 8.13.4

## [1.14.0-bb.1] - 2024-04-29

### Added

- Support for delivering custom network policies via values yaml

## [1.14.0-bb.0] - 2024-04-25

### Changed

- gluon updated from 0.4.9 to 0.4.10
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.13.1 to 8.13.2
- ironbank/elastic/kibana/kibana updated from 8.13.1 to 8.13.2

## [1.13.0-bb.1] - 2024-04-16

### Changed

- Updated prometheus-elasticsearch-exporter from 5.3.1 to 5.7.0
- Updated elasticsearch-exporter to 1.7.0
- Updated renovate file to track prometheus-elasticsearch-exporter

## [1.13.0-bb.0] - 2024-04-09

### Changed

- gluon updated from 0.4.8 to 0.4.9
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.13.0 to 8.13.1
- ironbank/elastic/kibana/kibana updated from 8.13.0 to 8.13.1

## [1.12.0-bb.1] - 2024-03-18

### Added

- Added Virtual Service for ElasticSearch

## [1.12.0-bb.0] - 2024-04-02

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.12.2 to 8.13.0
- ironbank/elastic/kibana/kibana updated from 8.12.2 to 8.13.0

## [1.11.0-bb.1] - 2024-03-12

### Changed

- Add egress whitelist

## [1.11.0-bb.0] - 2024-02-28

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.12.1 to 8.12.2
- ironbank/elastic/kibana/kibana updated from 8.12.1 to 8.12.2

## [1.10.0-bb.4] - 2024-02-21

### Changed

- Changed cypress test logic to (hopefully) be more reliable

## [1.10.0-bb.3] - 2024-02-19

### Fixed

- Fixed selector to allow the istio ingress gateway

## [1.10.0-bb.2] - 2024-02-19

### Added

- Added default principal from jaeger namespace to the list of allowed principals for the jaeger-es-index-templates

## [1.10.0-bb.1] - 2024-02-15

### Changed

- Updated the allow-all-in-namespace istio auth policy

## [1.10.0-bb.0] - 2024-02-07

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.12.0 to 8.12.1
- ironbank/elastic/kibana/kibana updated from 8.12.0 to 8.12.1

## [1.9.0-bb.3] - 2024-02-03

### Changed

- gluon updated from 0.4.7 to 0.4.8

## [1.9.0-bb.2] - 2024-02-02

### Changed

- Updated to Gluon 0.4.7
- Removed cypress config as it is now coming from Gluon

## [1.9.0-bb.1] - 2024-01-31

### Changed

- renaming authorization policies to avoid conflict with loki in the logging namespace

## [1.9.0-bb.0] - 2024-01-18

### Changed

- gluon updated from 0.4.6 to 0.4.7
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.11.3 to 8.12.0
- ironbank/elastic/kibana/kibana updated from 8.11.3 to 8.12.0

## [1.8.0-bb.1] - 2024-01-11

### Changed

- Add Istio Authorization Policies

## [1.8.0-bb.0] - 2024-01-04

### Changed

- gluon updated from 0.4.5 to 0.4.6
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.11.2 to 8.11.3
- ironbank/elastic/kibana/kibana updated from 8.11.1 to 8.11.3

## [1.7.0-bb.1] - 2023-12-18

### Changed

- updated elasticsearch-exporter security context

## [1.7.0-bb.0] - 2023-12-17

### Changed

- gluon updated from 0.4.4 to 0.4.5
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.11.0 to 8.11.2
- ironbank/elastic/kibana/kibana updated from 8.11.0 to 8.11.1

## [1.6.1-bb.4] - 2023-12-15

### Updated

- Updated bb base image to 2.1.0
- ironbank/stedolan/jq updated from 1.6 to 1.7
- ironbank/elastic/kibana/kibana updated from 8.10.4 to 8.11.0
- ironbank/elastic/elasticsearch/elasticsearch updated from 8.10.3 to 8.11.2
- prometheus-elasticsearch-exporter updated from 4.14.0 to 4.15.0

## [1.6.1-bb.3] - 2023-11-30

### Changed

- Updating OSCAL Component File.

## [1.6.1-bb.2] - 2023-11-02

### Changed

- gluon updated from 0.4.1 to 0.4.4
- elasticsearch-exporter image updated to 1.6.0

## [1.6.1-bb.1] - 2023-10-24

### Changed

- fixing cypress tests to work in multiple configurations so that BB pipelines will pass.

## [1.6.1-bb.0] - 2023-10-24

### Changed

- ironbank/elastic/kibana/kibana updated from 8.9.1 to 8.10.4

## [1.6.0-bb.0] - 2023-10-16

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.10.2 to 8.10.3

## [1.5.0-bb.0] - 2023-10-11

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.9.0 to 8.10.2
- ironbank/elastic/kibana/kibana updated from 8.9.0 to 8.9.1

## [1.4.0-bb.1] - 2023-10-06

### Updated

- Updated OSCAL version from 1.0.0 to 1.1.1

## [1.4.0-bb.0] - 2023-10-2

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.7.1 to 8.9.0
- ironbank/elastic/kibana/kibana updated from 8.7.1 to 8.9.0

## [1.3.1-bb.3] - 2023-09-29

### Added

- Fixed cypress test for BB pipeline

## [1.3.1-bb.2] - 2023-09-27

### Added

- Cypress modernization updates
- Updated gluon to 0.4.1
- Added npm package files, updated cypress file sturcture and file names to meet cypress 13.x requirements

## [1.3.1-bb.1] - 2023-05-26

### Added

- Added SCC and NetworkAttachmentDefinition for OpenShift

## [1.3.1-bb.0] - 2023-05-24

### Added

- Optional section in values for Elastic Agent config

## [1.3.0-bb.0] - 2023-05-11

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.6.0 to 8.7.0
- ironbank/elastic/kibana/kibana updated from 8.6.1 to 8.7.1

## [1.2.0-bb.0] - 2023-04-06

### Added

- Added networkpolicy for fluentbit ingress

## [1.1.0-bb.1] - 2023-03-01

### Added

- Exporter image added to chart.yaml and test images

## [1.1.0-bb.0] - 2023-02-10

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.5.2 to 8.6.0
- ironbank/elastic/kibana/kibana updated from 8.5.3 to 8.6.1

## [1.0.0-bb.0] - 2023-01-24

### Changed

- Rename chart to `elasticsearch-kibana`
- Graduate chart to stable v1

## [0.14.2-bb.0] - 2023-01-17

### Changed

- Update gluon to new registry1 location + latest version (0.3.2)

## [0.14.1-bb.0] - 2023-01-13

### Changed

- ironbank/elastic/kibana/kibana updated from 8.5.2 to 8.5.3
- Updated chart version to `0.14.1-bb.0`

## [0.14.0-bb.0] - 2022-12-09

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.5.0 to 8.5.2
- ironbank/elastic/kibana/kibana updated from 8.5.0 to 8.5.2

## [0.13.0-bb.0] - 2022-11-12

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.4.3 to 8.5.0
- ironbank/elastic/kibana/kibana updated from 8.4.3 to 8.5.0

## [0.12.1-bb.1] - 2022-11-09

### Changed

- Support for metrics mTLS

### Added

- Add PeerAuthentication for metrics

## [0.12.1-bb.0] - 2022-10-23

### Added

- Added Grafana Dashboard

## [0.12.0-bb.0] - 2022-10-18

### Changed

- ironbank/elastic/elasticsearch/elasticsearch updated from 8.4.2 to 8.4.3
- ironbank/elastic/kibana/kibana updated from 8.4.2 to 8.4.3

## [0.11.2-bb.0] - 2022-10-18

### Changed

- ingress-monitoring NetworkPolicy matchLabel bug fix

## [0.11.1-bb.0] - 2022-10-17

### Added

- Add Prometheus Service Monitor Template & monitoring value

## [0.11.0-bb.0] - 2022-09-29

### Changed

- Updated chart version to `0.11.0-bb.0`
- Updated appVersion, Kibana, and Elasticsearch to `8.4.2`

## [0.10.1-bb.0] - 2022-09-11

### Added

- .gitignore

## [0.10.1-bb.0] - 2022-09-11

### Added

- prometheus-elastiseaerch-exporter added as sub-chart deployment and `metrics` key to monitor health of elastic search indexes

## [0.10.0-bb.0] - 2022-08-29

### Changed

- Updated chart version to `0.10.0-bb.0`
- Updated appVersion, Kibana, and Elasticsearch to `8.4.0`

## [0.9.0-bb.2] - 2022-08-26

### Changed

- Added renovate post upgrade tasks

## [0.9.0-bb.1] - 2022-08-17

### Changed

- Added universal drops for capabilities to containers' securityContexts
- Edited naming of VolumeMounts to default

## [0.9.0-bb.0] - 2022-07-15

### Changed

- Updated chart version to `0.9.0-bb.0`
- Updated appVersion to `8.3.2`
- Updated Kibana to `8.3.1`
- Updated Elasticsearch to `8.3.2`

## [0.8.0-bb.1] - 2022-06-28

### Changed

- Updated bb base image to 2.0.0
- Updated gluon to 0.2.10

## [0.8.0-bb.0] - 2022-06-15

### Changed

- Updated chart version to `0.8.0-bb.0`
- Updated appVersion, Kibana, and Elasticsearch to `8.2.3`
- Updated gluon version to `0.2.9`
- Updated upgradeJob from `8.4` to `1.18.0`

## [0.7.1-bb.0] - 2022-06-01

### Changed

- hostname to domain value swap in chart/values.yaml

## [0.7.0-bb.3] - 2022-04-10

### Added

- mTLS exception for Mattermost
- Mattermost integration value for above resource and newtorkPolicies

## [0.7.0-bb.2] - 2022-04-10

### Added

- Enabled Istio PeerAuthentications to default to mTLS STRICT

## [0.7.0-bb.1] - 2022-03-24

### Changed

- Added Tempo Zipkin Egress Policy

## [0.7.0-bb.0] - 2022-03-17

### Changed

- Updated chart version to `0.7.0-bb.0`
- Updated image tags and version to `7.17.1`
- Updated `upgrade-job.yaml` to fascilitate rolling updates from `7.16.*` to `7.17.*`

## [0.6.0-bb.2] - 2022-01-31

### Added

- Update Chart.yaml to follow new standardization for release automation

### Changed

- Added renovate check to update new standardization

## [0.6.0-bb.1] - 2022-01-19

### Added

- Added OSCAL Component with NIST 800-53 control mapping

## [0.6.0-bb.0] - 2022-01-12

### Changed

- Updated to latest Ironbank images (`7.16.2`)

## [0.5.0-bb.1] - 2022-01-12

### Added

- moved bbtests values

## [0.5.0-bb.0] - 2021-12-30

### Added

- Added values support for podAnnotations in Elasticsearch
- Added values support for podAnnotations in Kibana

## [0.4.0-bb.0] - 2021-12-22

### Added

- Added values support for tolerations in Elasticsearch
- Added values support for tolerations in Kibana
- Updated README.md with override values for tolerations

## [0.3.0-bb.1] - 2021-12-16

### Added

- Added a check to the cypress test to look for log entries coming in from the various other components. This check can be toggled by setting the cypress_expect_logs env variable to true/false, and should be disabled in cases where no log entries are expected like package tests.
- Misc. updates to the cypress test.
- Updated gluon to 0.2.4.

## [0.3.0-bb.0] - 2021-12-15

### Changed

- Updated to latest Ironbank images (`7.16.1`)

## [0.2.0-bb.0] - 2021-12-07

### Changed

- Updated to latest Ironbank images (`7.14.0` for Kibana, `7.14.1` for Elastic)
- Updated Renovate to pick up changes for `version` values and `appVersion`

### Added

- Document for how to complete a package update
- New `kibana.host` value for overriding new `publicBaseUrl` config value for Kibana

## [0.1.24-bb.0] - 2021-11-17

### Added

- Added values support for tolerations in Elasticsearch
- Added values support for tolerations in Kibana
- Updated README.md with override values for tolerations

## [0.1.24-bb.0] - 2021-11-17

### Added

- Added values support for tolerations in Elasticsearch
- Added values support for tolerations in Kibana
- Updated README.md with override values for tolerations

## [0.1.23-bb.0] - 2021-11-04

### Added

- Added values support for imagePullPolicy in Elasticsearch
- Added values support for imagePullPolicy in Kibana
- Updated README.md with override values for imagePullPolicy
- Updated README.md to standardized Big Bang README

## [0.1.22-bb.0] - 2021-11-15

### Changed

- Added Rolling update strategy

## [0.1.21-bb.3] - 2021-10-21

### Changed

- Updated Upgrade Job to work with Istio Injection
- Added kill istio sidecar line

## [0.1.21-bb.2] - 2021-10-14

### Changed

- Added Network Policy to allow BB CI helm tests

## [0.1.21-bb.1] - 2021-10-13

### Changed

- Decreased default cpu resource request and limits

## [0.1.21-bb.0] - 2021-09-07

### Changed

- Migrated from bb-test-lib to gluon

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

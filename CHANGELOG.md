# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.7-bb.0] - 2021-04-06

### Added
- Updated configuration for istio mTLS communication for elasticsearch services.
- Istio DestinationRule for Elasticsearch http service.

### Changed
- Disabled xpack authc tokens for temporary API token access.

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

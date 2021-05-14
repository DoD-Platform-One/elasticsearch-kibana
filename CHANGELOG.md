# Changelog

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---
## [0.1.10-bb.2] - 2021-05-17
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

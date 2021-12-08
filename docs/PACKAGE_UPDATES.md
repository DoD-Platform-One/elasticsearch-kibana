# Code Changes for Updates

Elastic/Kibana is a Big Bang built/maintained chart. The below details the steps required to update to a new version of the package.

1. Ensure that newest elastic/kibana images are compatible. If possible the image tags should be the same, although patch version differences are OK.

2. Checkout the `renovate/ironbank` branch. This branch should already have the updates you need for the images, `elasticsearch.version`, `kibana.version` and `appVersion` in `Chart.yaml`. Validate that the `version` values are equal to their respective `image.tag` value and that the `appVersion` is equal to the elasticsearch version.

3. Modify the `version` in `Chart.yaml`. Since this is an upstream chart you should bump the versioning following semver, and append `-bb.0`. In general for new elastic/kibana versions this will mean bumping the minor version (i.e. `0.1.2-bb.0` to `0.2.0-bb.0`).

4. Update `CHANGELOG.md` adding an entry for the new version and noting all changes (at minimum should include `Updated Elastic/Kibana to x.x.x`).

5. Generate the `README.md` updates by following the [guide in gluon](https://repo1.dso.mil/platform-one/big-bang/apps/library-charts/gluon/-/blob/master/docs/bb-package-readme.md).

6. If this is a new minor version of Elastic you will likely need to add a new section to `chart/templates/bigbang/upgrade-job.yaml` for the new version upgrade. Follow the existing examples to update the job to support upgrades between old version -> new version.

7. Push up your changes, validate that CI passes. If there are any failures follow the information in the pipeline to make the necessary updates and reach out to the team if needed.

8. Perform the steps below for manual testing. CI provides a good set of basic smoke tests but it is beneficial to run some additional checks.

# Manual Testing for Updates

NOTE: For these testing steps it is good to do them on both a clean install and an upgrade. For clean install, point logging to your branch. For an upgrade do an install with logging pointing to the latest tag, then perform a helm upgrade with logging pointing to your branch.

You will want to install with:
- Logging (elastic, eck operator, and fluentbit), and Istio packages enabled
- Istio enabled
- [Dev SSO values](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/blob/master/chart/dev-sso-values.yaml) for Logging

Testing Steps:
- Ensure all pods go to running (NOTE: this is especially important for the upgrade testing since Big Bang has an "auto rolling upgrade" job in place)
- Login to Kibana without SSO, using the password in the `logging-ek-es-elastic-user` secret and username `elastic`
- Navigate to https://kibana.bigbang.dev/app/management/security/role_mappings and add a role mapping for SSO logins (name: sso, roles: superuser, mapping rules: username=*)
- Logout and attempt to perform an SSO login with your login.dso.mil credentials
- Navigate to https://kibana.bigbang.dev/app/management/kibana/indexPatterns and add an index pattern for `logstash-*`
- Navigate to `Analytics` -> `Discover` and validate that pod logs are appearing in the `logstash` index pattern

When in doubt with any testing or upgrade steps ask one of the CODEOWNERS for assistance.

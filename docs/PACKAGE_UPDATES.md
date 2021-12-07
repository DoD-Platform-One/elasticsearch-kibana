# Code Changes for Updates

Elastic/Kibana is a Big Bang built/maintained chart. The below details the steps required to update to a new version of the package.

1. Ensure that newest elastic/kibana images are compatible. If possible the image tags should be the same, although patch version differences are OK.

2. Checkout the `renovate/ironbank` branch. This branch should already have the updates you need for the images, `elasticsearch.version`, `kibana.version` and `appVersion` in `Chart.yaml`. Validate that the `version` values are equal to their respective `image.tag` value and that the `appVersion` is equal to the elasticsearch version.

3. Modify the `version` in `Chart.yaml`. Since this is an upstream chart you should bump the versioning following semver, and append `-bb.0`. In general for new elastic/kibana versions this will mean bumping the minor version (i.e. `0.1.2-bb.0` to `0.2.0-bb.0`).

4. Update `CHANGELOG.md` adding an entry for the new version and noting all changes (at minimum should include `Updated Jaeger to x.x.x`).

5. Generate the `README.md` updates by following the [guide in gluon](https://repo1.dso.mil/platform-one/big-bang/apps/library-charts/gluon/-/blob/master/docs/bb-package-readme.md).

6. Push up your changes, validate that CI passes. If there are any failures follow the information in the pipeline to make the necessary updates and reach out to the team if needed.

7. Perform the steps below for manual testing. CI provides a good set of basic smoke tests but it is beneficial to run some additional checks.

# Manual Testing for Updates

NOTE: For these testing steps it is good to do them on both a clean install and an upgrade. For clean install, point logging to your branch. For an upgrade do an install with logging pointing to the latest tag, then perform a helm upgrade with logging pointing to your branch.

You will want to install with:
- Logging (elastic, eck operator, and fluentbit), Istio and Monitoring packages enabled
- Istio enabled
- [Dev SSO values](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/blob/master/chart/dev-sso-values.yaml) for Logging

Testing Steps:
- TBD

When in doubt with any testing or upgrade steps ask one of the CODEOWNERS for assistance.

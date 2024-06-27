# How to upgrade the Elasticsearch-Kibana chart

Elasticsearch-Kibana is a Big Bang built/maintained chart, there is no upstream chart. The below details the steps required to update to a new version of the package.

1. Ensure that newest elastic/kibana images are compatible. If possible the image tags should be the same, although patch version differences are OK.

2. Checkout the `renovate/ironbank` branch.
    - This branch should already have the updates you need for the images, `elasticsearch.version`, `kibana.version` and `appVersion` in `Chart.yaml`. Validate that the `version` values are equal to their respective `image.tag` value and that the `appVersion` is equal to the elasticsearch version.

3. Modify the `version` in `Chart.yaml`.
    - Since this is an upstream chart you should bump the versioning following semver, and append `-bb.0`. In general for new elastic/kibana versions this will mean bumping the minor version (i.e. `0.1.2-bb.0` to `0.2.0-bb.0`). This value is usually updated automatically by renovate bot.

4. Update dependencies and binaries using `helm dependency update ./chart`
    - Pull assets and commit the binaries as well as the Chart.lock file that was generated.

        ```shell
        helm dependency update ./chart
        ```

    - **If the `bitnami/elasticsearch-exporter` image is being updated:**
      - Check the [upstream prometheus-elasticsearch-exporter
Chart.yaml](https://github.com/prometheus-community/helm-charts/blob/main/charts/prometheus-elasticsearch-exporter/Chart.yaml) file to see if there is a new chart released with the new image update

        - If a new chart exists with the new image, from the root of the repo run the following command:
            - Run a KPT package update

              ```shell
              kpt pkg update chart/deps/prometheus-elasticsearch-exporter@prometheus-elasticsearch-exporter-<version> --strategy alpha-git-patch
              ```

            - Update the `file://./deps/prometheus-elasticsearch-exporter` chart version in `chart/Chart.yaml`, image version in `chart/values.yaml` and `tests/images.txt`

            - Last, update dependencies and binaries using `helm dependency update ./chart`.

              **Note:** Any time any file in the `chart/deps/prometheus-elasticsearch-exporter` directory (or a sub-directory thereof) is changed, you must run `helm dependency update ./chart` to rebuild `chart/charts/prometheus-elasticsearch-exporter-<version>.tgz`.

        - Otherwise (if a new chart does not exist with the new image), skip this image update and continue to `Step 5.`

5. Update `CHANGELOG.md` adding an entry for the new version and noting all changes (at minimum should include `Updated Elasticsearch-Kibana to x.x.x`).

6. Generate the `README.md` updates by following the [guide in gluon](https://repo1.dso.mil/platform-one/big-bang/apps/library-charts/gluon/-/blob/master/docs/bb-package-readme.md).
    - Renovate bot may have already performed this step for you as well! 🤖

7. If this is a new minor version of Elastic you will likely need to add a new section to `chart/templates/bigbang/upgrade-job.yaml` for the new version upgrade. Follow the existing examples to update the job to support upgrades between old version -> new version.

8. Push up your changes, add upgrade notices if applicable, validate that CI passes.
    - If there are any failures, follow the information in the pipeline to make the necessary updates.
    - Add the `debug` label to the MR for more detailed information.
    - Reach out to the CODEOWNERS if needed.

9. Follow the `Testing a new Elasticsearch-Kibana version` section of this document for manual testing.

# Testing a new Elasticsearch-Kibana version

> NOTE: For these testing steps it is good to do them on both a clean install and an upgrade. For clean install, point Elasticsearch-Kibana to your branch. For an upgrade do an install with Elasticsearch-Kibana pointing to the latest tag, then perform a helm upgrade with Elasticsearch-Kibana pointing to your branch.

You will want to install with:

- [ECK-Operator](https://repo1.dso.mil/big-bang/product/packages/eck-operator/-/blob/main/docs/DEVELOPMENT_MAINTENANCE.md)
  - Operator for elasticsearch and kibana deployments
- [FluentBit](https://repo1.dso.mil/big-bang/product/packages/fluentbit/-/blob/main/docs/DEVELOPMENT_MAINTENANCE.md)
  - Log aggregator for kibana
- Istio enabled
- [Dev SSO values](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/blob/master/docs/assets/configs/example/dev-sso-values.yaml) for Logging

The following overrides file can be used for a bare minimum `Elasticsearch-Kibana` deployment:

`overrides/elasticsearchKibana.yaml`

```yaml
kiali:
  enabled: false

kyverno:
  enabled: false

kyvernoPolicies:
  enabled: false

kyvernoReporter:
  enabled: false

promtail:
  enabled: false

loki:
  enabled: false

neuvector:
  enabled: false

tempo:
  enabled: false

monitoring:
  enabled: true

grafana:
  enabled: false

addons:
  metricsServer:
    enabled: false

istio:
  enabled: true

eckOperator:
  enabled: true
  git:
    tag: null
    branch: renovate/ironbank

elasticsearchKibana:
  enabled: true
  git:
    tag: null
    branch: renovate/ironbank
  license:
    trial: true

fluentbit:
  enabled: true
```

Or with SSO enabled:

`overrides/elasticsearchKibana-sso.yaml`

```yaml
kiali:
  enabled: false

kyverno:
  enabled: false

kyvernoPolicies:
  enabled: false

kyvernoReporter:
  enabled: false

promtail:
  enabled: false

loki:
  enabled: false

neuvector:
  enabled: false

tempo:
  enabled: false

grafana:
  enabled: false

addons:
  metricsServer:
    enabled: false

istio:
  enabled: true

monitoring:
  enabled: true
  sso:
    enabled: true
    prometheus:
      client_id: platform1_a8604cc9-f5e9-4656-802d-d05624370245_bb8-prometheus
    alertmanager:
      client_id: platform1_a8604cc9-f5e9-4656-802d-d05624370245_bb8-alertmanager

eckOperator:
  enabled: true

elasticsearchKibana:
  enabled: true
  git:
    tag: null
    branch: renovate/ironbank
  sso:
    enabled: true
    client_id: platform1_a8604cc9-f5e9-4656-802d-d05624370245_bb8-kibana
  license:
    trial: true

fluentbit:
  enabled: true
```

Testing Steps:

- Ensure all pods go to running (NOTE: this is especially important for the upgrade testing since Big Bang has an "auto rolling upgrade" job in place)
- Login to Kibana with [default credentials](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/guides/using-bigbang/default-credentials.md), using the password in the `logging-ek-es-elastic-user` secret and username `elastic`

    ```shell
    kubectl get secrets -n logging logging-ek-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'; echo
    ```

- Navigate to <https://kibana.dev.bigbang.mil/app/management/security/role_mappings> and add a role mapping for SSO logins (name: sso, roles: superuser, mapping rules: username=*)
- Logout and attempt to perform an SSO login with your login.dso.mil credentials
- Navigate to <https://kibana.dev.bigbang.mil/app/management/kibana/indexPatterns> and add any index pattern to test (ex: `logstash-*`)
- Navigate to `Analytics` -> `Discover` and validate that pod logs are appearing in the `logstash` index pattern

When in doubt with any testing or upgrade steps ask one of the CODEOWNERS for assistance.

## automountServiceAccountToken

The mutating Kyverno policy named `update-automountserviceaccounttokens` is leveraged to harden all ServiceAccounts in this package with `automountServiceAccountToken: false`. This policy is configured by namespace in the Big Bang umbrella chart repository at [chart/templates/kyverno-policies/values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/templates/kyverno-policies/values.yaml?ref_type=heads).

This policy revokes access to the K8s API for Pods utilizing said ServiceAccounts. If a Pod truly requires access to the K8s API (for app functionality), the Pod is added to the `pods:` array of the same mutating policy. This grants the Pod access to the API, and creates a Kyverno PolicyException to prevent an alert.

# How to upgrade the Elasticsearch-Kibana chart

Elasticsearch-Kibana is a Big Bang built/maintained chart, there is no upstream chart. The below details the steps required to update to a new version of the package.

1. Ensure that newest elastic/kibana images are compatible. If possible the image tags should be the same, although patch version differences are OK.

2. Checkout the `renovate/ironbank` branch.
    - This branch should already have the updates you need for the images, `elasticsearch.version`, `kibana.version` as well as `version` and `appVersion` in `Chart.yaml`. Validate that the `version` values are equal to their respective `image.tag` value and that the `appVersion` is equal to the elasticsearch version.

3. Update dependencies and binaries using `helm dependency update ./chart`
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

4. Ensure that `CHANGELOG.md` has been updated by verifying or updating the entry for the new version and noting all changes (at minimum should include `Updated Elasticsearch-Kibana to x.x.x`).

5. Push up your changes, add upgrade notices if applicable, validate that CI passes.
    - If there are any failures, follow the information in the pipeline to make the necessary updates.
    - Add the `debug` label to the MR for more detailed information.
    - Reach out to the CODEOWNERS if needed.

6. As part of your MR that modifies bigbang packages, you should modify the bigbang  [bigbang/tests/test-values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/tests/test-values.yaml?ref_type=heads) against your branch for the CI/CD MR testing by enabling your packages.

    - To do this, at a minimum, you will need to follow the instructions at [bigbang/docs/developer/test-package-against-bb.md](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/developer/test-package-against-bb.md?ref_type=heads) with changes for Elasticsearch-Kibana enabled (the below is a reference, actual changes could be more depending on what changes where made to Elasticsearch-Kibana in the package MR).

    - For Elasticsearch-Kibana to pass CI/CD MR testing, <b>it is required to set Fluent Bit enabled to true</b> in the tests/test-values.yaml.

### [test-values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/tests/test-values.yaml?ref_type=heads)

```yaml
eckOperator:
  # -- Toggle deployment of ECK Operator.
  enabled: true

fluentbit:
  enabled: true # For MR CI/CD smoke test Elasticsearch-Kibana requires fluentbit.enabled to be set to true.

elasticsearchKibana:
  enabled: true
  git:
    tag: null
    branch: renovate/ironbank
  values:
    istio:
      hardened:
        enabled: true
  ### Additional components of Elasticsearch-Kibana should be changed to reflect testing changes introduced in the package MR
```

6. Follow the `Testing a new Elasticsearch-Kibana version` section of this document for manual testing.

## Testing a new Elasticsearch-Kibana version

- Run Helm Unittests
  - Make sure that you have helm unitests installed
  - run `helm unittest chart` will run all tests under `chart/tests/*_test.yaml`

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
alloy:
  enabled: false 

kiali:
  enabled: false

kyverno:
  enabled: true

kyvernoPolicies:
  enabled: true

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

eckOperator:
  enabled: true

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
alloy:
  enabled: false

kiali:
  enabled: false

kyverno:
  enabled: true

kyvernoPolicies:
  enabled: true

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

1. Ensure all pods go to running (NOTE: this is especially important for the upgrade testing since Big Bang has an "auto rolling upgrade" job in place)
2. If kyverno and kyvernoPolicies are enabled to `true` skip this step, otherwise if set to `false` in the `overrides/elasticsearchKibana.yaml` for testing the following secrets will need to be copied from the logging namespace to fluentbit in order to successfully test fluentbit log shipping to elasticsearch. See [fluentbit/DEVELOPMENT_MAINTENANCE.md manual testing for more detailed information](https://repo1.dso.mil/big-bang/product/packages/fluentbit/-/blob/main/docs/DEVELOPMENT_MAINTENANCE.md?ref_type=heads&plain=0#manual-testing-for-updates).
    - `logging-ek-es-http-certs-public`
    - `logging-ek-es-http-certs-internal`
    - `logging-ek-es-elastic-user`

3. Log in to Kibana with [default credentials](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/guides/using-bigbang/default-credentials.md), using the password in the `logging-ek-es-elastic-user` secret and username `elastic`

    ```shell
    kubectl get secrets -n logging logging-ek-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'; echo
    ```

4. *Note*: This instruction is only relevant if SSO was enabled, skip otherwise. Navigate to <https://kibana.dev.bigbang.mil/app/management/security/role_mappings> and add a role mapping for SSO logins (name: sso, roles: superuser, mapping rules: username=*)
5. Logout and attempt to perform an SSO login with your login.dso.mil credentials
6. Navigate to <https://kibana.dev.bigbang.mil/app/discover#/> and click `Create data view` to add an index pattern to test (ex: `logstash-*`)
7. Navigate to `Analytics` -> `Discover` and validate that pod logs are appearing in the `logstash` index pattern

When in doubt with any testing or upgrade steps ask one of the CODEOWNERS for assistance.

## automountServiceAccountToken

The mutating Kyverno policy named `update-automountserviceaccounttokens` is leveraged to harden all ServiceAccounts in this package with `automountServiceAccountToken: false`. This policy is configured by namespace in the Big Bang umbrella chart repository at [chart/templates/kyverno-policies/values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/templates/kyverno-policies/values.yaml?ref_type=heads).

This policy revokes access to the K8s API for Pods utilizing said ServiceAccounts. If a Pod truly requires access to the K8s API (for app functionality), the Pod is added to the `pods:` array of the same mutating policy. This grants the Pod access to the API, and creates a Kyverno PolicyException to prevent an alert.

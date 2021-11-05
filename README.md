# Elasticsearch-Kibana Documentation

# Table of Contents

- [Overview](docs/overview.md)
- [Development](#elasticsearch-kibana)
- [Prerequisites](#pre-requisites)
- [IronBank Images](#iron-bank)
- [Deployment](#deployment)
- [Enterprise License](#enterprise-license)
- [Elastic Password](#elastic-password)
- [Upgrading](#upgrading)
- [BigBang Specifics](#big-bang-specific-configuration)
- [Configuration Values](#Values)
- [Kibana Metrics](docs/prometheus.md)
- [Kibana ECK Integration](docs/elastic.md)
- [Kibana SSO Integration](docs/keycloak.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Backup and recovery](docs/backup.md)

---

# elasticsearch-kibana

- Thin chart wrapper around a deployment of Elasticsearch and Kibana using the [ECK Operator](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).
- This chart is owned by Big Bang and does not point to an upstream chart provided by Elastic or another vendor.
- Open an [issue](https://repo1.dso.mil/platform-one/big-bang/apps/core/elasticsearch-kibana/-/issues) if you would like to request a feature or submit an issue that needs to be fixed/addressed.

## Pre-Requisites

The ECK Operator must be deployed beforehand in order to leverage the `Elasticsearch` and `Kibana` custom resources. You can use the full [BigBang](https://repo1.dso.mil/platform-one/big-bang/bigbang) solution or the individual [eck operator chart](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).

Elastic requires that the vm.max_map_count be set to `vm.max_map_count=262144`. This is best set via sysctl on the nodes themselves before installation. If this is not possible an alternative method of setting this value is available [here](https://repo1.dso.mil/platform-one/big-bang/apps/core/elasticsearch-kibana/-/tree/main/docs/sysctls.md).

## Iron Bank

You can `pull` the registry1 image(s) [here](https://registry1.dso.mil/harbor/projects/3/repositories/elastic%2Felasticsearch%2Felasticsearch) and view the container approval [here](https://ironbank.dso.mil/ironbank/repomap/elastic/elasticsearch).

## Deployment

```bash
git clone https://repo1.dso.mil/platform-one/big-bang/apps/core/elasticsearch-kibana.git
cd elasticsearch-kibana
helm install elasticsearch-kibana chart --debug -n logging --create-namespace -f chart/values.yaml
```

## Enterprise License

If you want to experiment with enterprise features for development, you can toggle on a trial license. This is done in the [BigBang](https://repo1.dso.mil/platform-one/big-bang/bigbang) values as shown below:

```yaml
logging:
  license:
    trial: true
```

For production, if you want enterprise features you will need to add your license in the BigBang values as shown below:

```yaml
logging:
  license:
    trial: false
    keyJSON: |
      {"license":
        {"uid":....
        }
      }
```

NOTE: You can also squash the license onto a single line as follows, but ensure no quotes are present and you turn it into a multiline value with a Helm pipe:

```yaml
logging:
  license:
    trial: false
    keyJSON: |
      {"license":{"uid":....}}
```

## Elastic Password

The default "admin" `elastic` user has its password stored in a secret. To login initially and set up additional users or SSO (see [the Keycloak doc](./docs/keycloak.md)) you need to get this password:

```bash
kubectl get secrets -n logging logging-ek-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
```

## Upgrading

Please always check [CHANGELOG](./CHANGELOG.md) before upgrading to a new chart version.

## Big Bang Specific Configuration

#### AutoRollingUpgrade

BigBang's chart for elasticsearch-kibana comes with the following variable `autoRollingUpgrade` and when enabled checks for minor version changes in the Elasticsearch and Kibana resource and automatically does the following in accordance with Elastic's [Rolling Upgrades documentation](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/rolling-upgrades.html#_upgrading_your_cluster):

1. Annotate the Kibana resource to temporarily disconnect it from the ECK-Operator's control and delete the Kibana deployment. This is because Kibana can only be upgraded once Elasticsearch is upgraded and of Green Health status. Kibana has a high probability of issues if it is not stopped while Elasticsearch is ApplyingChanges.
2. Shard allocation is disabled on the Elasticsearch cluster.
3. Stop of non-essential indexing and performing a synced-flush.
4. Re-enable shard allocation once Elasticsearch is showing Green Health status on the new version.
5. Annotate the Kibana resource to allow it to be managed by the ECK-Operator again, at which point a new Kibana Deployment will rollout.

- More can be read about excluding elastic resource from being managed by the operator [here](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-upgrading-eck.html).
- You can keep an eye on this upgrade by viewing the health of the Elasticsearch installation being upgraded `kubectl get elasticsearch -A` (will list all Elasticsearches in the cluster, upgrading ones will show ApplyingChanges).
- You can view the logs of the rolling-upgrade job running in the same namespace as your elasticsearch-kibana package installation, which will be in the format of `bb-logging-ek-upgrade-XXXXX`. The container will print progress and what it may be waiting on.
- Each Elasticsearch node will restart one by one (controlled by the ECK-Operator) and once ES is healthy, Kibana will re-deploy via one of the last functions of the rolling-upgrade job.
- BigBang flux values have the HelmRelease timeout for the EK package set at 20 minutes. If you have a cluster with more than 8 nodes you should up the timeout accordingly via the `logging.flux.timeout` Value. Each Elasticsearch node takes about 2-2.5 minutes to restart.

#### Node Types (Roles)

BigBang's chart for Elasticsearch Kibana allows configuration for the following types of nodes within an Elasticsearch cluster:

- master
- data
- ml
- ingest
- coordinating

Only the first two nodes (master & data) are required and enabled by default.

## Values

| Parameter                                                         | Description                                                                                                                            | Default                                                               |
| ----------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.affinity`        | Configurable options are "soft" and "hard" [antiAffinity][]                                                                            | `""`                                                                  |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.count`           | Kubernetes replica count for the Deployment (i.e. how many pods for elasticsearch nodes)                                               | see [values](./chart/values.yaml)                                     |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.heap`            | Configurable setting for java [JVM heap](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-jvm-heap-size.html) min + max amount | `2g`                                                                  |
| `{kibana\|elasticsearch}.imagePullSecrets`                        | Configuration for [imagePullSecrets][] so that you can use a private registry for your image                                           | `[ ]`                                                                 |
| `{kibana\|elasticsearch}.image.repository`                        | The image repository URL                                                                                                               | see [values](./chart/values.yaml)                                     |
| `{kibana\|elasticsearch}.image.tag`                               | Configurable tag applied to the image.                                                                                                 | `7.9.2`                                                               |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.initContainers`  | Allows for creation of an initContainer for the Elasticsearch Master or Data nodes. Kibana initContainer support coming soon           | `[]`                                                                  |
| `istio`                                                           | Configurable istio VirtualService for Kibana external access                                                                           | see [values](./chart/values.yaml)                                     |
| `kibanaBasicAuth`                                                 | Configurable setting for Kibana to enable/disable basic authentication support for the UI                                              | `enabled: true`                                                       |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.nodeAffinity`    | Configurable [nodeAffinity][] applied to master or data nodes to run on specific nodes                                                 | `{}`                                                                  |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.nodeSelector`    | Configurable [nodeSelector][] so that you can target specific nodes for your Kibana instances                                          | `{}`                                                                  |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.persistence`     | Configurable [persistence][] for persistent volume storage, can set storageClassName and size                                          | see [values](./chart/values.yaml)                                     |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.resources`       | Allows you to set the [resources][] for the indivudial Deployments for Elasticsearch nodes                                             | see [values](./chart/values.yaml)                                     |
| `kibana.resources`                                                | Allows you to set the [resources][] for the Deployment of Kibana                                                                       | see [values](./chart/values.yaml)                                     |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.securityContext` | Allows you to set the [securityContext][] for the elasticsearch node pods                                                              | see [values](./chart/values.yaml)                                     |
| `kibana.securityContext`                                          | Allows you to set the [securityContext][] for the kibana pods pods                                                                     | see [values](./chart/values.yaml)                                     |
| `elasticsearch.{master\|data\|ingest\|coord\|ml}.lifecycle`       | Allows you to set the [containerLifecycleHooks][] for the indivudial Deployments for Elasticsearch nodes                               | see [values](./chart/values.yaml)                                     |
| `elasticsearch.{ingest\|coord\|ml}.enabled`                       | Boolean to enable the different types of nodes within an Elasticsearch stack                                                           | `false`                                                               |
| `sso`                                                             | Configurable SSO integration with OIDC                                                                                                 | see [values](./chart/values.yaml) & [documentation](docs/keycloak.md) |
| `{kibana\|elasticsearch}.version`                                 | Configurable version setting for the eck-operator to handle the version of kibana or elasticsearch                                     | `7.9.2`                                                               |
| `autoRollingUpgrade.enabled`                                      | Boolean setting to enable BigBang job to perform an Elastic [Rolling Upgrade][]                                                        | `true`                                                                |
| `openshift`                                                       | Boolean setting if deploying on Openshift                                                                                              | `false`                                                               |

[antiaffinity]: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity
[containerlifecyclehooks]: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks
[imagepullsecrets]: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret
[nodeselector]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
[persistence]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes
[resources]: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
[securitycontext]: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
[rolling upgrade]: https://www.elastic.co/guide/en/elasticsearch/reference/7.10/rolling-upgrades.html#_upgrading_your_cluster

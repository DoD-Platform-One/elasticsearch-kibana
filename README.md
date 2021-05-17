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
- [Configuration](#configuration)
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

The ECK Operator must be deployed beforehand in order to leverage the `Elasticsearch` and `Kibana` custom resources.  You can use the full [BigBang](https://repo1.dso.mil/platform-one/big-bang/bigbang) solution or the individual [eck operator chart](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).

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

1. Annotate the Kibana resource to temporarily disconnect it from the ECK-Operator's control. This is because Kibana can only be upgraded once Elasticsearch is upgraded and of Green Health status. More can be read about excluding elastic resource from being managed by the operator [here](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-upgrading-eck.html).
2. Shard allocation is disabled on the Elasticsearch cluster.
3. Stop of non-essential indexing and running a synced flush.
4. Re-enable shard allocation once Elasticsearch is showing Green Health status on the new version.
5. Annotate the Kibana resource to allow it to be managed by the ECK-Operator again, at which point a new Kibana Deployment will rollout.

## Configuration

| Parameter                                    | Description                                                                                                                                        | Default                                                               |
|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| `elasticsearch.{master\|data}.antiAffinity`   | Configurable options are "soft" and "hard" [antiAffinity][]                                                                                        | `""`                                                                  |
| `elasticsearch.{master\|data}.count`          | Kubernetes replica count for the Deployment (i.e. how many pods for elasticsearch nodes)                                                           | `3`                                                                   |
| `elasticsearch.heap`                         | Configurable setting for java [JVM heap](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-jvm-heap-size.html) min + max amount             | `1g`                                                                  |
| `{kibana\|elasticsearch}.imagePullSecrets`    | Configuration for [imagePullSecrets][] so that you can use a private registry for your image                                                       | `[ ]`                                                                 |
| `{kibana\|elasticsearch}.image.repository`    | The image repository URL                                                                                                                           | see [values](./chart/values.yaml)                                     |
| `{kibana\|elasticsearch}.image.tag`           | Configurable tag applied to the image.                                                                                                             | `7.9.2`                                                               |
| `elasticsearch.{master\|data}.initContainers` | Allows for creation of an initContainer for the Elasticsearch Master or Data nodes. Kibana initContainer support coming soon                       | `[]`                                                                  |
| `istio`                                      | Configurable istio VirtualService for Kibana external access                                                                                       | see [values](./chart/values.yaml)                                     |
| `kibanaBasicAuth`                            | Configurable setting for Kibana to enable/disable basic authentication support for the UI                                                          | `enabled: true`                                                       |
| `elasticsearch.{master\|data}.nodeAffinity`   | Configurable [nodeAffinity][] applied to master or data nodes to run on specific nodes                                                             | `{}`                                                                  |
| `elasticsearch.{master\|data}.nodeSelector`   | Configurable [nodeSelector][] so that you can target specific nodes for your Kibana instances                                                      | `{}`                                                                  |
| `elasticsearch.{master\|data}.persistence`    | Configurable [persistence][] for persistent volume storage, can set storageClassName and size                                                      | see [values](./chart/values.yaml)                                     |
| `{kibana\|elasticsearch}.resources`           | Allows you to set the [resources][] for the indivudial Deployments, kibana, es master and es data                                                  | see [values](./chart/values.yaml)                                     |
| `securityContext`                            | Allows you to set the [securityContext][] for the container                                                                                        | see [values](./chart/values.yaml)                                     |
| `sso`                                        | Configurable SSO integration with OIDC                                                                                                             | see [values](./chart/values.yaml) & [documentation](docs/keycloak.md) |
| `{kibana\|elasticsearch}.version`             | Configurable version setting for the eck-operator to handle the version of kibana or elasticsearch                                                 | `7.9.2`                                                               |
| `autoRollingUpgrade`                          | Boolean setting to enable BigBang job to perform an Elastic [Rolling Upgrade][]                                                                    | `true`

[antiAffinity]: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity
[imagePullSecrets]: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/#create-a-pod-that-uses-your-secret
[nodeSelector]: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#nodeselector
[persistence]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes
[resources]: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
[securityContext]: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-pod
[Rolling Upgrade]: https://www.elastic.co/guide/en/elasticsearch/reference/7.10/rolling-upgrades.html#_upgrading_your_cluster

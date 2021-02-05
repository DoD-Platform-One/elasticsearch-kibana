# Elasticsearch-Kibana Documentation
 
# Table of Contents
- [Development](#elasticsearch-kibana)
- [Prerequisites](#pre-requisites)
- [IronBank Images](#iron-bank)
- [Deployment](#deployment)
- [Enterprise License](#enterprise-license)
- [Elastic Password](#elastic-password)
- [Kibana Metrics](docs/prometheus.md)
- [Kibana ECK Integration](docs/elastic.md)
- [Kibana SSO Integration](docs/keycloak.md)

---

# elasticsearch-kibana

Thin chart wrapper around a deployment of Elasticsearch and Kibana using the [ECK Operator](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).

## Pre-Requisites

The ECK Operator must be deployed beforehand in order to leverage the `Elasticsearch` and `Kibana` custom resources.  You can use the full [BigBang]() solution or the individual [eck operator chart](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).

## Iron Bank

You can `pull` the registry1 image(s) [here](https://registry1.dso.mil/harbor/projects/3/repositories/elastic%2Felasticsearch%2Felasticsearch) and view the container approval [here](https://ironbank.dso.mil/ironbank/repomap/elastic/elasticsearch).

## Deployment
```bash
git clone https://repo1.dso.mil/platform-one/big-bang/apps/core/elasticsearch-kibana.git
cd elasticsearch-kibana
helm install elasticsearch-kibana chart --debug
```

## Enterprise License

If you want to experiment with enterprise features for development, you can toggle on a trial license. This is done in the BigBang values as shown below:

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
kubectl get secrets -n logging logging-ek-es-elastic-user -o yaml | grep elastic: | awk 'NR==1{printf $2}' | base64 -d | xargs echo
```

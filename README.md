# Elasticsearch-Kibana Documentation
 
# Table of Contents
- [Development](#elasticsearch-kibana)
- [Prerequisites](#pre-requisites)
- [IronBank Images](#iron-bank)
- [Deployment](#deployment)
- [Kibana Metrics](docs/prometheus.md)
- [kibana ECK Integration](docs/elastic.md)
- [kibana SSO Integration](docs/Keycloak.md)

---

# elasticsearch-kibana

Thin chart wrapper around a deployment of Elasticsearch and Kibana using the [ECK Operator](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).

## Pre-Requisites

The ECK Operator must be deployed beforehand in order to leverage the `Elasticsearch` and `Kibana` custom resources.  You can use the full [BigBang]() solution or the individual [eck operator chart](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).

## Iron Bank

You can `pull` the registry1 image(s) [here](https://registry1.dso.mil/harbor/projects/3/repositories/elastic%2Felasticsearch%2Felasticsearch) and view the container approval [here](https://ironbank.dso.mil/ironbank/repomap/elastic/elasticsearch).

## Deployment
```
git clone https://repo1.dso.mil/platform-one/big-bang/apps/core/elasticsearch-kibana.git
cd elasticsearch-kibana
helm install elasticsearch-kibana chart --debug
```

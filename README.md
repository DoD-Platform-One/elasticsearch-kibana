# elasticsearch-kibana

Thin chart wrapper around a deployment of Elasticsearch and Kibana using the [ECK Operator](https://repo1.dsop.io/platform-one/big-bang/apps/core/eck-operator).

## Pre-Requisites

The ECK Operator must be deployed beforehand in order to leverage the `Elasticsearch` and `Kibana` custom resources.  You can use the full [BigBang]() solution or the individual [eck operator chart](https://repo1.dsop.io/platform-one/big-bang/apps/core/eck-operator).

## Iron Bank

You can `pull` the registry1 image(s) [here](https://registry1.dsop.io/harbor/projects/3/repositories/elastic%2Felasticsearch%2Felasticsearch) and view the container approval [here](https://ironbank.dsop.io/ironbank/repomap/elastic/elasticsearch).
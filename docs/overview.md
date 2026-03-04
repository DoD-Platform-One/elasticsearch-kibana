# Overview of the Elastic Stack

## Architecture

ECK enables the provisioning of Elasticsearch using the [Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/).

This enables setup and management of Elasticsearch, Kibana, APM Server, Enterprise Search, and Beats on Kubernetes. The chart provides customizable [Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) for deploying your Elasticsearch clusters.

Before you can create the custom resources, you would have to deploy the [ECK Operator](https://repo1.dso.mil/big-bang/product/packages/eck-operator).

This chart installs Custom Resources for the Elasticsearch and Kibana resource types. For more information on the CRs for further customization, look at the [elasticsearch](https://github.com/elastic/cloud-on-k8s/blob/main/config/samples/elasticsearch/elasticsearch.yaml) and [kibana](https://github.com/elastic/cloud-on-k8s/blob/main/config/samples/kibana/kibana_es.yaml) sample manifests.

A more detailed [architecture overview](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/charter/packages/elasticsearch-kibana/Architecture.md) details how the components interact in a Big Bang deployment.

## External Resources

The following links provide more information on Elasticsearch on Kubernetes:

- [Running the Elastic Stack on Kubernetes](https://www.youtube.com/watch?v=Wf6E3vkvEFM&t=2261s)
- [Elasticsearch Architecture and Scaling](https://www.youtube.com/watch?v=YsYUgZu9-Y4&list=RDQM3CS9KywI3RE&start_radio=1)
- [How To Use The Elastic Stack as a SIEM](https://www.youtube.com/watch?v=v69kyU5XMFI)

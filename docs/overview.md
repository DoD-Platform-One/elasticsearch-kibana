### Overview of the Elastic Stack

ECK enables the provisioning of Elasticsearch using the [Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/).

This enables setup and management of Elasticsearch, Kibana, APM Server, Enterprise Search, and Beats on Kubernetes.  The chart provides customizable [Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) for deploying your elasticsearch clusters.

Before you can create the custom resources , you would have to deploy the [ECK Operator](https://repo1.dso.mil/platform-one/big-bang/apps/core/eck-operator).

This chart installs Custom Resources for the Elasticsearch and Kibana resource type.  However , to find more information on the CRs for more customization , look at the [elasticsearch](https://github.com/elastic/cloud-on-k8s/blob/1.5/config/samples/elasticsearch/elasticsearch.yaml) and [kibana](https://github.com/elastic/cloud-on-k8s/blob/1.5/config/samples/kibana/kibana_es.yaml) sample manifests.

A more detailed [architecture overview](https://repo1.dso.mil/platform-one/big-bang/bigbang/-/blob/master/charter/packages/elasticsearch-kibana/Architecture.md) details how the components interact in a bigbang deployment.

### External resources for learning more

The following links provide more information on elasticsearch on kubernetes.

* [Running the ELastic Stack on Kubernetes](https://www.youtube.com/watch?v=Wf6E3vkvEFM&t=2261s)
* [Elasticsearch Architecture and scaling](https://www.youtube.com/watch?v=YsYUgZu9-Y4&list=RDQM3CS9KywI3RE&start_radio=1)
* [How To Use The Elastic Stack as a SIEM](https://www.youtube.com/watch?v=v69kyU5XMFI)

## Logs from the ECK stack

#### Pre-requisites
- ECK stack deployed

#### Getting Started

- Login to Kibana
  - username: elastic
  - Password : can be obtained by querying kubectl get secret elasticsearch-es-elastic-user -n elastic -o yaml
- Create Index by  selecting Management icon from the left menu and  clicking Index patterns under Kibana.  In the Create Index patterns enter <logstash-*> and click create index pattern.  In the the next step Click on the dropdown and select "@timestamp"

- For Search click on Discovery from the side menu

- In KQL textbox enter `kubernets.namespace.name : elastic`

- Click Refresh/Update

- Note: Logs from the monitoring stack can be viewd on Kibana. The default index pattern is logstash-*. Logs for the entire ECK stack can be procured by filtering on the "elastic" namespace.

Further filters that can be used are:

#### Kibana

  - `kubernetes.pod_name`   = `Kibana Pod Name` to get logs from a specific  pod
     - `kubernetes.container_name` = `kibana` to get logs from kibana container

####  Elasticsearch Pods

  - `kubernetes.pod_name`   = `elastic-es-default-#` to get logs from a specific # pod
     - `kubernetes.container_name` = `elasticsearch` or `elastic-internal-init-filesystem` to get logs from a specific container within the pod
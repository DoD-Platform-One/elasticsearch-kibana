## Troubleshooting

#### AutoRollingUpgrade

Once upgraded an elasticsearch cluster won't be able to roll back to the previous version in the event the cluster is unhealthy after a minor version upgrade and the `autoRollingUpgrade` commands are attempted.

- If your elasticsearch pods are not restarting and you have 1 data node and 1 master node, the ECK-Operator will not auto re-deploy the pods since as soon as 1 node goes offline the cluster will go health status Red, so you need to manually kick the pods starting with the data node first.

Check ff your Elasticsearch cluster is Unhealthy and status "Red":

```bash
kubectl get elasticsearches -A
```

- If the ek HelmRelease states "Upgrade tries Exhausted" and Elasticsearch or Kibana is in a bad state check the logs for the ECK-Operator and see if nodes need to be manually restarted:

  ```bash
  kubectl logs elastic-operator-0 -n eck-operator
  ```

  If you see logs like the following:

  ```
  {"log.level":"info","@timestamp":"2021-04-16T20:57:24.771Z","log.logger":"driver","message":"Cannot restart some nodes for upgrade at this time","service.version":"1.3.0+6db1914b","service.type":"eck","ecs.version":"1.4.0","namespace":"logging","es_name":"logging-ek","failed_predicates":{"...":["logging-ek-es-data-0","logging-ek-es-master-0"]}}
  ```

  Manually delete the pods mentioned in the log, eg: starting with "logging-ek-es-data-0" & then "logging-ek-es-master-0" if it still isn't terminating after data is 2/2 Ready.

- If Elasticsearch has upgraded and showing Green/Yellow Health status but new Kibana pods are stuck at 1/2 check the logs for Kibana and Elasticsearch:

  ```bash
  kubectl logs -l common.k8s.elastic.co/type=kibana -n logging -c kibana
  kubectl logs logging-ek-es-data-0 -n logging -c elasticsearch
  ```

  If Kibana shows the following logs:

  ```
  "message":"[search_phase_execution_exception]: all shards failed"}
  ```

  Check Elasticsearch logs for the troublesome indexes:

  ```
  "Caused by: org.elasticsearch.action.search.SearchPhaseExecutionException: Search rejected due to missing shards [[.kibana_task_manager_1][0]]. Consider using `allow_partial_search_results` setting to bypass this error."
  ```

  Perform the following commands to delete the `.kibana_task_manager_X` index. WARNING This will erase any Kibana configuration, Index Mappings, Dashboards, Role Mappings, etc.

  ```bash
  kubectl port-forward svc/logging-ek-es-http -n logging 9200:9200
  curl -XDELETE -ku "elastic:ELASTIC_USER_PASSWORD" "https://localhost:9200/.kibana_task_manager_1"
  ```

#### Error Failed to Flush Chunk

The Fluentbit pods on the Release Cluster may have ocasional issues with reliably sending their 2000+ logs per minute to ElasticSearch because ES is not tuned properly

Warnings/Errors should look like:

```
[ warn] [engine] failed to flush chunk '1-1625056025.433132869.flb', retry in 257 seconds: task_id=788, input=storage_backlog.2 > output=es.0 (out_id=0)
[error] [output:es:es.0] HTTP status=429 URI=/_bulk, response:
{"error":{"root_cause":[{"type":"es_rejected_execution_exception","reason":"rejected execution of coordinating operation [coordinating_and_primary_bytes=105667381, replica_bytes=0, all_bytes=105667381, coordinating_operation_bytes=2480713, max_coordinating_and_primary_bytes=107374182]"}]
```

Fix involves increasing `resource.requests`, `resource.limits`, and `heap` for ElasticSearch data pods in `chart/values.yaml`

```yaml
logging:
  values:
    elasticsearch:
      data:
        resources:
          requests:
            cpu: 2
            memory: 10Gi
          limits:
            cpu: 3
            memory: 14Gi
        heap:
          min: 4g
          max: 4g
```

#### Error Cannot Increase Buffer

In a heavily utilized production cluser, an intermitent warning that the buffer could not be increased may appear

Warning:

```
[ warn] [http_client] cannot increase buffer: current=32000 requested=64768 max=32000
```

Fix involves increasing the `Buffer_Size` within the Kubernetes Filter in fluentbit/chart/values.yaml

```yaml
fluentbit:
  values:
    config:
      filters: |
        [FILTER]
            Name kubernetes
            Match kube.*
            Kube_CA_File /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
            Kube_Token_File /var/run/secrets/kubernetes.io/serviceaccount/token
            Merge_Log On
            Merge_Log_Key log_processed
            K8S-Logging.Parser On
            K8S-Logging.Exclude Off
            Buffer_Size 1M
```

#### Yellow ES Health Status and Unassigned Shards

After a BigBang `autoRollingUpgrade` job, cluster shard allocation may not have been properly re-enabled resulting in a yellow health status for the ElasticSearch cluster and Unassigned Shards

To check Cluster Health run:

```
kubectl get elasticsearch -A
```

To view the sttus of shards run:

```
curl -XGET -H 'Content-Type: application/json' -ku "elastic:$(kubectl get secrets -n logging logging-ek-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')" "https://localhost:9200/_cat/shards?h=index,shard,prirep,state,un
assigned.reason"
```

To fix, run the following commands:

```
kubectl port-forward svc/logging-ek-es-http -n logging 9200:9200

curl -XPUT -H 'Content-Type: application/json' -ku "elastic:$(kubectl get secrets -n logging logging-ek-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')" "https://localhost:9200/_cluster/settings" -d '{ "index.routing.allocation.disable_allocation": false }'

curl -XPUT -H 'Content-Type: application/json' -ku "elastic:$(kubectl get secrets -n logging logging-ek-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')" "https://localhost:9200/_cluster/settings" -d '{ "transient" : { "cluster.routing.allocation.enable" : "all" } }'
```

#### CPU/Memory Limits and Heap

CPU/Memory limits and Heap must be configured to match and have sufficient resources with the heap min and max equal in `chart/values.yaml`

```yaml
  master:
    resources:
      limits:
        cpu: 1
        memory: 4Gi
      requests:
        cpu: 1
        memory: 4Gi
    heap:
      # -- Elasticsearch master Java heap Xms setting
      min: 2g
      # -- Elasticsearch master Java heap Xmx setting
      max: 2g
```

#### Crash due to too low map count

VM Max Map Count must be set or it will result in a crash due to the default OS limits on nmap being too low
Must be set as root in `/etc/sysctl.conf` and verified by running `sysctl vm.max_map_count`
Automatically set in k3d-dev.sh

```
sysctl -w vm.max_map_count=262144
```

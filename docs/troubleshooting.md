## Troubleshooting

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

To check Cluster Health run:

```
kubectl get elasticsearch -A
```

To view the status of shards run:

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

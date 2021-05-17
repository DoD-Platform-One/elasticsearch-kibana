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



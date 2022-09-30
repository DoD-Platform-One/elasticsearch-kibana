# Elastic Exporter Metrics

## Reference Documentation

* [Upstream Exporter Repository](https://github.com/prometheus-community/elasticsearch_exporter)
* [Elastic Docs for Working with API Keys](https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-create-api-key.html)

## Overview 

The Elasticsearch Exporter needs authentication configured to be able to scrape information and serve up metrics:
* By default (similar to fluent-bit) the built-in `elastic` superuser account is fed in to be able to authenticate. 
* There is also support for utilizing an API_KEY to communicate with the ES Cluster which is recommended for production installations.

## Using an API Key 

The Exporter only needs read only permission to the cluster and it's indices. The following policy that must be applied via `curl -XPOST` creates a Key and Role for just those permissions:

```json
_security/api_key

{   
    "name": "prom-exporter",  
    "role_descriptors": {    
        "prom-monitoring": {      
            "cluster": [
                "monitor", 
                "monitor_snapshot"
            ],      
            "index": [ 
              { 
                "names": ["*"], 
                "privileges": ["monitor"] 
              } 
            ] 
        } 
    } 
}
```

This can be applied within a BigBang cluster with the following 2 commands (run on two separate windows/panes/terminals/etc):

```shell
kubectl port-forward svc/logging-ek-es-http -n logging 9200:9200
```
&
```shell
curl -XPOST -H 'Content-Type: application/json' -ku "elastic:$(kubectl get secrets -n logging logging-ek-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')" "https://localhost:9200/_security/api_key" -d '{   "name": "prom-exporter",  "role_descriptors": {    "prom-monitoring": {      "cluster": ["monitor", "monitor_snapshot"],      "index": [ { "names": ["*"], "privileges": ["monitor"] } ] } } }'
```

The above comand will return the reponse of:
```shell
{"id":"XXXXXXXXXXXXXXXXXXXX","name":"prom-exporter","api_key":"XXXXXXXXXXXXXXXXXXXXXX","encoded":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=="}
```

Make sure to save the `"encoded"` portion and adjust your `logging` value overrides to match the following:
```yaml
logging:
  values:
    metrics:
      env:
        ES_API_KEY: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=="
        ES_USERNAME: ""
      extraEnvSecrets: null
```

This will disable the BigBang built in mapping of the `elastic` user and instead utilize only the configured `ES_API_KEY`

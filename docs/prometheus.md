# Kibana Prometheus integration 


This integration will require a dockerfile in order to take advantage of kibana's metrics. 
The docker file will make use of an exporter, which is found here: https://github.com/pjhampton/kibana-prometheus-exporter/

1. Create a dockerfile within your eck repository and paste the following code into the file.  This is an Iron Bank Image you are building from:
```
FROM registry.dsop.io/platform-one/apps/eck/kibana-ib:7.8.0

RUN cd /usr/share/kibana && /usr/share/kibana/bin/kibana-plugin install https://github.com/pjhampton/kibana-prometheus-exporter/releases/download/7.8.0/kibana-prometheus-exporter-7.8.0.zip --allow-root 

USER kibana
```
2. Run <code>docker build . -t registry.dsop.io/platform-one/apps/eck/kibana/kibana-prom:7.8.0-prom</code> to build the image 
* Make sure you are at the file directory with the dockerfile. 
3. Run <code>docker push registry.dsop.io/platform-one/apps/eck/kibana/kibana:7.8.0-prom</code> to push the image into your registry. 
4. Create a directory 'monitoring/prometheus' within your kibana directory
5. Make files named 'KibanaServiceMonitor.yaml', 'role.yaml' , 'roleBinding.yaml', 'kustomization.yaml', 'secret.yaml'
6. Copy the folllowing code into KibanaServiceMonitor.yaml:
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    prometheus: k8s
    app.kubernetes.io/instance: kibana
  name: kibana
  namespace: elastic
spec:
  selector:
    matchLabels:
      common.k8s.elastic.co/type: kibana
  namespaceSelector:
    matchNames:
      - elastic
  endpoints:
    - interval: 30s
      path: "/_prometheus/metrics"
      params:
        format: 
          - prometheus
      targetPort: 5601
      scheme: http
      jobLabel: kibana
      basicAuth:
        password:
          name: elasticsearch-es-elastic-user
          key: elastic
        username: 
          name: kibana-user
          key: user

```
7. Copy the following code into role.yaml
```yaml
apiVersion: rbac.authorization.k8s.io/v1
items:
- apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
    name: prometheus-k8s
    namespace: elastic
  rules:
  - apiGroups:
    - ""
    resources:
    - services
    - endpoints
    - pods
    verbs:
    - get
    - list
    - watch
kind: RoleList

```
8. Copy the following code into roleBinding.yaml
```yaml
apiVersion: rbac.authorization.k8s.io/v1
items:
- apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: prometheus-k8s
    namespace: elastic
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: Role
    name: prometheus-k8s
  subjects:
  - kind: ServiceAccount
    name: prometheus-k8s
    namespace: monitoring
kind: RoleBindingList

```
9. Copy the following code into secret.yaml
```yaml
data:
  user: ZWxhc3RpYw==
kind: Secret
metadata:
  name: kibana-user
  namespace: elastic

```
10. Copy the following code into kustomization.yaml
```yaml 
namespace: elastic 

resources:
  - KibanaServiceMonitor.yaml
  - role.yaml
  - roleBinding.yaml
  - secret.yaml

``` 
11. add /monitoring/prometheus/ to your kustomization.yaml that is NOT in monitoring
12. Create a file named patch.yaml in your /internal/ kibana directory, and copy the following code into that file:
```yaml
apiVersion: kibana.k8s.elastic.co/v1
kind: Kibana
metadata:
  labels:
    app: kibana
  name: kibana
spec:
  version: 7.8.0-prom
  count: 1
  elasticsearchRef:
    name: elasticsearch
  config:
    kibana-prometheus-exporter.user: ${PROMETHEUS_USERNAME}
    kibana-prometheus-exporter.pass: ${PROMETHEUS_PASSWORD}
  http:
    tls: 
      selfSignedCertificate:
        disabled: true
  podTemplate:
    metadata:
      labels:
        app: kibana
      annotations:
        sidecar.istio.io/rewriteAppHTTPProbers: "true"
    spec:
      automountServiceAccountToken: true
      containers:
        - name: kibana
          env:
            - name: PROMETHEUS_USERNAME
              value: "elastic"
            - name: PROMETHEUS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: elasticsearch-es-elastic-user
                  key: elastic
```
13. Add the following into the kustomization.yaml of your /internal/ directory
```yaml 
patchesStrategicMerge: 
- patch.yml
``` 
Make sure this code has its own section, and is not part of the resources in the kustomization. 
14. Once all steps are done, run your pipeline. 
15. Once the pipeline is built, go to your prometheus URL, and check the steps for verification detailed below. 

## Verification
Prometheus has been sucessfully integrated if the following occured
* All of Kibana's pods appear in the targets page and display with a status of UP
    * Targets page is found by first clicking on 'Status', then clicking on 'Targets'
    * By default, there is one metric pod for Kibana: elastic/kibana/0
* Kibana's commands appear in the query
    * This can be verified by typing in 'Kibana' in the expression field. A list of anchore associated commands should appear after typing 'Kibana', including but not limted to: kibana_status,  etc...
        * Details about the kibana's metric commands can be found in the metrics.md file. 
    * Each of Kibana's commands must be able to execute without err and return a value.
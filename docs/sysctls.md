# Sysctls Configuration

## Managing Sysctls via Init Containers

It is possible to use built-in init containers to set sysctls. This is needed for Elasticsearch to set the value of `vm.max_map_count`.

Note that the recommended way to set sysctls is by setting them directly on the cluster nodes. If this is not possible there are a couple of options.

The `values.yaml` file provides access to the Elasticsearch `serviceAccountName`. This ServiceAccount will be auto-created and used by Elastic — it defaults to `logging-elasticsearch`.

```yaml
elasticsearch:
  serviceAccountName: "logging-elasticsearch"
```

> **Note:** PodSecurityPolicy (PSP) was removed in Kubernetes 1.25 and is not available in clusters meeting the Big Bang minimum requirement of Kubernetes ≥ 1.32. The ClusterRole/ClusterRoleBinding approach using `podsecuritypolicies` shown in older documentation is no longer valid. Use Kyverno policies or node-level sysctl configuration instead.

## Using a DaemonSet

It is possible to create a DaemonSet that achieves the same goal as init containers without giving the Elastic pod elevated privileges.

The DaemonSet must use an IronBank-approved image. Use `registry1.dso.mil/ironbank/redhat/ubi/ubi8` rather than public images such as `busybox`.

An example is given below:

```yaml
---
# Deny all network access to the pod
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ek-node-prep-deny-all
spec:
  podSelector:
    matchLabels:
      app: ek-node-prep
  policyTypes:
  - Ingress
  - Egress
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: elasticsearch-ds
  namespace: logging
  labels:
    app: ek-node-prep
spec:
  selector:
    matchLabels:
      name: elasticsearch-ds
  template:
    metadata:
      labels:
        name: elasticsearch-ds
        app: ek-node-prep
      annotations:
        sidecar.istio.io/inject: "false"
    spec:
      serviceAccount: logging-elasticsearch
      containers:
      - name: elasticsearch-ds
        securityContext:
          privileged: true
        image: registry1.dso.mil/ironbank/redhat/ubi/ubi8:8.3
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        command:
        - "/bin/sh"
        - "-c"
        - |
          set -o errexit
          set -o xtrace
          while sysctl -w vm.max_map_count=262144
          do
            sleep 300s
          done
```

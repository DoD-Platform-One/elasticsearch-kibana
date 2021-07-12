### Managing Sysctls via Init Containers

It is possible to use the built in initContainers to set the sysclts. This is needed for Elastic to set the values of vm.max_map_count.

Note that the reccomended way to set the sysctls is by setting them directly on the cluster nodes. If this is not possible there are a couple of options.

The values.yaml file provides access to the elasticsearch serviceAccountName. This serviceAccount will be auto-created for you and used by elastic - defaults to "logging-elasticsearch".

```
elasticsearch:
  serviceAccountName: "logging-elasticsearch"
```

An example of a service account that gives root access to the elastic pods (needed to give the init containers root) is given below.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ek-psp-role
rules:
- apiGroups:
  - policy
  resourceNames:
  - privileged
  resources:
  - podsecuritypolicies
  verbs:
  - use
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ek-sa-psp-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: ek-psp-role
subjects:
- kind: ServiceAccount
  name: logging-elasticsearch
  namespace: logging
```

### Using a Daemonset

It is possible to create a Daemonset that achieves the same goal as the init containers without giving the elastic pod root credentials.

An example is given below.

```
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
        image: busybox:latest
        # image: registry1.dso.mil/ironbank/redhat/ubi/ubi8:8.3
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
# Node Affinity & Anti-Affinity with Elastic/Kibana

Affinity and scheduling constraints are exposed through the `values.yaml` options for this package. To schedule your pods onto specific nodes, you can utilize the `nodeSelector` field for simple constraints or the `affinity` field for more complex logic.

For a deep dive into how Kubernetes handles these rules, refer to the [official Kubernetes documentation on scheduling](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity).

---

## Simple Node Selection (`nodeSelector`)

The `nodeSelector` is the simplest form of node selection constraint. It requires the node to have labels that match every key-value pair specified.

**Example:** Scheduling pods to nodes labeled with a specific `node-type`.

```yaml
kibana:
  nodeSelector:
    node-type: kibana

elasticsearch:
  master:
    nodeSelector:
      node-type: elastic-master
  data:
    nodeSelector:
      node-type: elastic-data
```

---

## Advanced Node Affinity (`nodeAffinity`)

Use `nodeAffinity` for more expressive rules, such as logical OR operators or "soft" preferences that allow pods to schedule elsewhere if the preferred nodes are full.

> **Note:** The example below uses `requiredDuringSchedulingIgnoredDuringExecution` (Hard Affinity). If the labels do not match, the pods will remain in a **Pending** state.

```yaml
kibana:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: node-type
            operator: In
            values:
            - "kibana"

elasticsearch:
  master:
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: node-type
              operator: In
              values:
              - "elastic-master"
  data:
    affinity:
      nodeAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          nodeSelectorTerms:
          - matchExpressions:
            - key: node-type
              operator: In
              values:
              - "elastic-data"
```

---

## Pod Anti-Affinity

Pod Anti-Affinity ensures that pods are not co-located on the same node (or rack). This is critical for high availability in Elasticsearch to ensure that master or data replicas are distributed across different physical hardware.

**Example:** Using `topologyKey: "kubernetes.io/hostname"` to ensure no two identical component pods land on the same node.

```yaml
kibana:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - topologyKey: "kubernetes.io/hostname"
          labelSelector:
            matchLabels:
              # Matches the label assigned to the component pods
              dont-schedule-with: kibana

elasticsearch:
  master:
    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          - topologyKey: "kubernetes.io/hostname"
            labelSelector:
              matchLabels:
                dont-schedule-with: elastic-master
  data:
    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          - topologyKey: "kubernetes.io/hostname"
            labelSelector:
              matchLabels:
                dont-schedule-with: elastic-data
```

---

## Best Practices & High Availability

* **Quorum Protection:** Always use Anti-Affinity for Elasticsearch **master** nodes. Losing multiple master nodes due to a single host failure can cause a cluster-wide outage.
* **Soft Anti-Affinity:** For larger clusters where you might have more pods than nodes (e.g., horizontal scaling), consider using `preferredDuringSchedulingIgnoredDuringExecution`. This allows the cluster to stay online even if optimal distribution isn't possible.
* **Resource Isolation:** Use `nodeSelector` or `nodeAffinity` to keep Elasticsearch data pods on nodes with high-performance SSD/NVMe storage for better I/O performance.
# Network Policies

This package uses the [bb-common](https://repo1.dso.mil/big-bang/product/packages/bb-common) library chart to generate all Kubernetes `NetworkPolicy` resources. Policies are declared entirely in `chart/values.yaml` using bb-common's shorthand notation and rendered via the single-line include in `chart/templates/bigbang/network-policies.yaml`.

Network policies are disabled by default (`networkPolicies.enabled: false`). The Big Bang umbrella chart sets `networkPolicies.enabled: true` at deploy time.

## Automatic Egress Defaults

When `networkPolicies.enabled: true`, bb-common automatically appends the following egress policies to every pod in the namespace (unless explicitly disabled):

- **DNS** — allows UDP/TCP port 53 to kube-dns
- **In-namespace** — allows all traffic within the `logging` namespace
- **Istio control plane** — allows egress to istiod for sidecar configuration

## Ingress Policies

| Target pod | Port | Allowed sources |
|------------|------|----------------|
| `elasticsearch` | `9200` | `kibana` pods in the `logging` namespace |
| `elasticsearch` | `9200` | `elastic-operator` in the `eck-operator` namespace |
| `elasticsearch` | `9200` | `jaeger` in the `jaeger` namespace |
| `elasticsearch` | `9200` | `fluent-bit` in the `fluentbit` namespace |
| `elasticsearch` | `9200` | `mattermost` in the `mattermost` namespace |
| `kibana` | `5601` | `elastic-operator` in the `eck-operator` namespace |
| `metrics` (exporter) | `9108` | `prometheus` in the `monitoring` namespace |

## Egress Policies

| Source pod | Allowed destination | Condition |
|------------|---------------------|-----------|
| `elasticsearch` | `sso` definition (Keycloak endpoint) | Only when `sso.enabled: true` |

## Custom `kubeAPI` Definition

This package overrides the built-in `kubeAPI` egress definition to use `0.0.0.0/0` (with `169.254.169.254/32` excluded) rather than the default RFC-1918 ranges, to accommodate clusters where the Kubernetes API is reachable via a public IP:

```yaml
networkPolicies:
  egress:
    definitions:
      kubeAPI:
        to:
          - ipBlock:
              cidr: 0.0.0.0/0
              except:
                - 169.254.169.254/32
```

## Adding Custom Policies

Additional policies can be declared using bb-common shorthand under `networkPolicies.egress.from` or `networkPolicies.ingress.to`. See the [bb-common network policy documentation](https://repo1.dso.mil/big-bang/product/packages/bb-common/-/blob/main/docs/network-policies/README.md) for the full shorthand syntax reference.

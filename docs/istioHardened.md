# Istio Hardened

Big Bang has added the `.Values.istio` map attribute to the values of applications that can be Istio-injected (when `.Values.istio.enabled` is `true`). This document walks through the impact of enabling Istio hardening on how traffic is managed within a given Istio-injected package.

## Prerequisites

In order for Istio hardening to have any impact, the package must also have `.Values.istio.enabled: true` set. This is because all of the resources created by hardening are applied to the Istio service mesh, which includes Istio sidecar proxies. If there are no Istio proxies, then no mesh components exist in the namespace and therefore Istio Kubernetes resources in the namespace will not affect anything.

## Enabling Istio Hardening

Istio configuration for this package is inherited automatically from the umbrella chart — nothing in the package values needs to be set directly. The configuration can be applied in two ways:

**Option 1 — Global Configuration (Via Istiod):**
The umbrella template reads `istiod.enabled` from the top-level `istiod` key in Big Bang and passes it as a global configuration to the Elasticsearch-Kibana package as `istio.enabled`. If hardening is enabled globally under the `istiod` package, the Elasticsearch-Kibana package automatically inherits `istio.sidecar.enabled: true`, `istio.authorizationPolicies.enabled: true`, and `istio.authorizationPolicies.generateFromNetpol: true`.

To enable hardening globally across your Big Bang deployment:

```yaml
istiod:
  enabled: true                     # Propagates istio.enabled: true to all packages
  values:                           
    hardened:
      enabled: true                 # Globally enables sidecars and authorization policies
    mtls:
      mode: STRICT                  # STRICT = mTLS only; PERMISSIVE = allows plain-text 
```

**Option 2 — Package-Specific Configuration (Elasticsearch-Kibana):**
At Helm render time, `bb-common.istio.render` reads the computed package values and generates the following from the `elasticsearchKibana.values.istio` block:
- A `PeerAuthentication` enforcing `STRICT` mTLS (configurable via `istio.mtls.mode`).
- A `Sidecar` restricting outbound traffic to `REGISTRY_ONLY` (configurable via `istio.sidecar.outboundTrafficPolicyMode`).
- `AuthorizationPolicy` resources auto-generated from `networkPolicies.ingress` rules, plus any defined in `istio.authorizationPolicies.custom`.

To enable hardening specifically for the Elasticsearch-Kibana package in your umbrella values:

```yaml
istiod:
  enabled: true                     # Propagates istio.enabled: true to all packages

elasticsearchKibana:            
  values:
    istio:                          # Configures Elasticsearch-Kibana specific Istio settings
      hardened:
        enabled: true               # Enables sidecar, authorizationPolicies, generateFromNetpol
      mtls:
        mode: STRICT                # STRICT = mTLS only; PERMISSIVE = allows plain-text alongside mTLS
      sidecar:
        outboundTrafficPolicyMode: "REGISTRY_ONLY"
```

> **Note:** The `istio.hardened` key is transparently migrated by the umbrella chart before values reach the package — `istio.hardened.customServiceEntries` is merged into `istio.serviceEntries.custom` and `istio.hardened.customAuthorizationPolicies` is merged into `istio.authorizationPolicies.custom`. The `hardened` key itself is removed before the package sees the values.

## REGISTRY_ONLY Istio Sidecar

When `istio.sidecar.enabled: true` is set, a `Sidecar` resource is applied to the package's namespace that sets the `outboundTrafficPolicy` to `REGISTRY_ONLY`. This means that for pods with an Istio proxy sidecar, only egress traffic destined for a service within the Istio service mesh registry is allowed.

By default, all Kubernetes Services are added to this registry. However, cluster-external hostnames, IP addresses, and other endpoints will NOT be reachable with this Sidecar in place. For example, if an application attempts to reach `kubernetes.default.svc.cluster.local`, the request will not be blocked. Conversely, if the application attempts to reach `s3.us-gov-west-1.amazonaws.com`, the request will fail unless there is a ServiceEntry that adds it to the service mesh registry. This Sidecar is added to provide defense in depth, working alongside NetworkPolicies to prevent data exfiltration.

## ServiceEntry Resources

Because some applications have well-documented requirements to reach cluster-external endpoints (S3 is one common example), ServiceEntries can be added to include those endpoints in the Istio service registry. If a required endpoint is missing, please open an issue. Alternatively, you can add custom ServiceEntries via the `istio.serviceEntries.custom` list:

```yaml
istio:
  enabled: true
  sidecar:
    enabled: true
  serviceEntries:
    custom:
     - name: "allow-google"
       enabled: true
       spec:
         hosts:
           - google.com
         location: MESH_EXTERNAL
         ports:
           - number: 443
             protocol: TLS
             name: https
         resolution: DNS
```

This would result in the following ServiceEntry being created:

```yaml
apiVersion: networking.istio.io/v1
kind: ServiceEntry
metadata:
  name: allow-google
  namespace: my-app-namespace
spec:
  hosts:
  - google.com
  location: MESH_EXTERNAL
  ports:
  - name: https
    number: 443
    protocol: TLS
  resolution: DNS
```

For more information on writing ServiceEntries, see [the Istio documentation](https://istio.io/latest/docs/reference/config/networking/service-entry/).

## Authorization Policies

[Istio Authorization Policies](https://istio.io/latest/docs/reference/config/security/authorization-policy/#AuthorizationPolicy) are created when `istio.authorizationPolicies.enabled: true`. When `istio.authorizationPolicies.generateFromNetpol: true`, policies are automatically generated from the package's `networkPolicies.ingress` configuration. There is a default deny policy which will deny everything not explicitly allowed. Denials appear as a `403` with the message `RBAC: access denied`.

### Custom Authorization Policies

Custom policies can be injected via the `istio.authorizationPolicies.custom` list:

```yaml
istio:
  authorizationPolicies:
    enabled: true
    custom:
    - name: "allow-my-namespace"
      enabled: true
      spec:
        selector:
          matchLabels:
            app.kubernetes.io/name: "server-app"
        action: ALLOW
        rules:
        - from:
          - source:
              namespaces:
              - "my-namespace"
```

This policy would be generated:

```yaml
apiVersion: security.istio.io/v1
kind: AuthorizationPolicy
metadata:
  name: "allow-my-namespace"
  namespace: {{ $.Release.Namespace }}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: "server-app"
  action: ALLOW
  rules:
  - from:
    - source:
        namespaces:
        - "my-namespace"
```

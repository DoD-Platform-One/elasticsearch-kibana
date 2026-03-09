### SSO/OIDC Configuration

The chart provides OIDC authentication with support for multiple identity providers. Configuration is defined once in `.Values.sso` and automatically injected into both Elasticsearch nodesets and Kibana.

**Files:**
- `templates/_helpers.tpl` - The `oidc` template generates `xpack.security.authc.realms.oidc.*` config for Elasticsearch nodesets
- `templates/_kibana-config.tpl` - Generates `xpack.security.authc.providers` for Kibana login UI
- `templates/bigbang/sso-secret.yaml` - Creates Secrets for OIDC client secrets (primary and additional providers)

**Features:**
- **Primary OIDC provider** - Configured via `sso.oidc.*` values
- **Additional OIDC providers** - Configured via `sso.additional_oidc` map (keyed by realm name)
- **Login button labels** - Customizable via `login_label` per provider
- **Provider ordering** - OIDC providers render first (alphabetically), basic auth last
- **Default scopes** - Includes `openid`, `profile`, `email`, `groups` for role mapping

**Example - Multiple OIDC Providers:**
```yaml
sso:
  enabled: true
  client_id: "primary-client-id"
  client_secret: "primary-secret"       # Can be in SOPS-encrypted values
  oidc:
    realm: PrimaryIDP
    issuer: "https://primary-idp.example.mil"
    auth_url: "https://primary-idp.example.mil/authorize"
    token_url: "https://primary-idp.example.mil/token"
    userinfo_url: "https://primary-idp.example.mil/userinfo"
    jwkset_url: "https://primary-idp.example.mil/keys"
    claims_principal: "preferred_username"
    claims_group: "groups"
    signature_algorithm: "RS256"
  login_label: "Primary Login"          # Button text on Kibana login screen

  additional_oidc:
    OktaRealm:                          # Map key becomes the realm name
      client_id: "okta-client-id"
      client_secret: "okta-secret"      # Can be in separate SOPS file for merge
      issuer: "https://your-org.okta.mil/oauth2/default"
      auth_url: "https://your-org.okta.mil/oauth2/default/v1/authorize"
      token_url: "https://your-org.okta.mil/oauth2/default/v1/token"
      userinfo_url: "https://your-org.okta.mil/oauth2/default/v1/userinfo"
      jwkset_url: "https://your-org.okta.mil/oauth2/default/v1/keys"
      claims_principal: "preferred_username"
      claims_group: "groups"
      signature_algorithm: "RS256"
      login_label: "Okta Login"         # Each provider gets its own button
```
### Network Policy and Istio Configuration

To support SSO/OIDC integrations, you must ensure your network policies and Istio configuration allow traffic to your Identity Provider (IdP). This is critical in Big Bang environments where "Default Deny" network policies and "Strict" Istio mTLS are enforced.

**1. Network Policies (Layer 3/4)**
You must allow egress traffic from the Elasticsearch/Kibana pods to the IdP's IP addresses. You can do this by either:
* **Option A (Global):** referencing the existing `sso` definition in the global `networkPolicies` (see [Big Bang values.yaml](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/chart/values.yaml?ref_type=heads)).
* **Option B (Custom):** defining a custom policy within the package values using the `bb-common` library structure.

**2. Istio Routes (Layer 7)**
If your IdP is external to the cluster (e.g., Okta, Azure, Google), you must creating a ServiceEntry to allow the mesh to resolve the hostname. Without this, strict mTLS will block the connection.

For more details, see the Big Bang [SSO Integration Guide](https://repo1.dso.mil/big-bang/bigbang/-/blob/master/docs/community/development/package-integration/sso.md) and the `bb-common` documentation for [Network Policies](https://repo1.dso.mil/big-bang/product/packages/bb-common/-/blob/main/docs/network-policies/README.md?ref_type=heads) and [Routes](https://repo1.dso.mil/big-bang/product/packages/bb-common/-/blob/main/docs/routes/README.md?ref_type=heads).

#### Example: Custom Network and Route Policy
```yaml
networkPolicies:
  enabled: true
  egress:
    definitions:
      # 1. Define the destination
      oidc-provider:
        to:
          - ipBlock:
              # In production, replace 0.0.0.0/0 with your IdP's specific CIDR ranges
              cidr: "0.0.0.0/0"
    from:
      # 2. Allow the Elasticsearch pods to reach that destination
      elasticsearch:
        podSelector:
          matchLabels:
            common.k8s.elastic.co/type: elasticsearch
        to:
          definition:
            oidc-provider: true

routes:
  outbound:
    # Key name identifies the route (do not use 's3' or generic names)
    oidc-provider:
      enabled: true
      hosts:
        - "accounts.google.com" # REPLACE with your IdP host
      location: MESH_EXTERNAL
      ports:
        - number: 443
          name: https
          protocol: HTTPS
      resolution: DNS
```

**How it works:**

1. **Elasticsearch nodesets** - Each nodeset in `templates/elasticsearch.yaml` includes `{{ include "oidc" $ }}` when `sso.enabled` is true. This injects all OIDC realm configurations (primary + additional) into every nodeset's config.

2. **Kibana login UI** - The `xpack.security.authc.providers` block in `_kibana-config.tpl` iterates over all configured OIDC providers, rendering them in alphabetical order by realm name, with basic auth rendered last.

3. **Secrets** - `sso-secret.yaml` iterates over the primary provider and all `additional_oidc` entries, creating secret entries only for providers that have `client_secret` defined. This allows non-secret values (client_id, URLs) to be in plain values.yaml while secrets stay in SOPS-encrypted files.

**Values merge pattern:** The `additional_oidc` map structure allows you to split configuration:
- Plain `values.yaml`: client_id, URLs, claims config
- SOPS `secrets.yaml`: client_secret per realm

Helm's values merge will combine them by realm key automatically.

### Kibana Config Deep-Merge

The chart builds Kibana configuration by composing defaults and merging user overrides. This ensures user-provided `.Values.kibana.config` values take precedence without completely replacing chart defaults.

**Files:**
- `templates/_kibana-config.tpl` - The `kibana.config` template

**Chart-provided defaults include:**
- `elasticsearch.hosts` - Set to HTTP when Istio is enabled (Istio handles TLS)
- `xpack.security.authc.providers` - OIDC provider config when SSO is enabled
- `server.publicBaseUrl` - Derived from routes or domain values
- Fleet configuration - When agent settings are provided
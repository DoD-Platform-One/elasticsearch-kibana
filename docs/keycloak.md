# Elastic / Kibana keycloak Integration

This document summarizes what manifest changes are required to integrate with keycloak. For configuration as checklist items and detailed keycloak configuration please see the documentation in this repo.

### Configuration as checklist

These are the items you need to do after keycloak and elastic search are working on your cluster. 

### Keycloak Configuration

### Prerequisites

Keycloak is configured with a working Realm including Groups and Users

#### Process

- Create an elastic OIDC client scope with the following mappings
  
  | Name     | Mapper Type      | Mapper Selection Sub | Token Claim Name   | Claim JSON Type |
  |----------|------------------|----------------------|--------------------|-----------------|
  | email    | user property    | email                | email              | string          |
  | group    | Group Membership | N/A                  | groups             | N/A             |
  | username | User Property    | username             | preferred_username | string          |
  
- Create an elastic client 
  - Change the following configuration items
    - access type: confidential _this will enable "Credentials"_
    - Direct Access Grants Enabled: Off
    - Valid Redirect URIs: kibana.${DOMAIN}/*
  - Set Client Scopes
    - Default Client Scopes: elastic (the client scope you created in the previous step)
    - optional client scopes: N/A
  - Take note of the client secret in the credential tab

To Verify evaluate a client scope, these fields should be present

```json
{
  "exp": 9999999999,
  "iat": 9999999999,
  "jti": "00000000-0000-0000-0000-000000000000",
  "iss": "https://keycloak.${dns}/auth/realms/{realm_name}",
  "sub": "00000000-0000-0000-0000-000000000000",
  "typ": "Bearer",
  "azp": "${client_id}",
  "session_state": "00000000-0000-0000-0000-000000000000",
  "acr": "1",
  "scope": "openid elastic",
  "groups": [
    "group_1",
    "...",
    "group_n"
  ],
  "preferred_username": "${username}",
  "email": "${email}"
}
```
## Elastic Configuration

See manifests/elasticsearch for a manifest patch example. These are the required updates to the default configuration of elasticsearch

- On each node set
  - Add xpack.security.authc.realms.oidc.${REALM_NAME} (This realm name is the keycloak realm configured)
  - The following items go below the realm configuration
    - order
    - rp
      - client_id
      - response_type
      - redirect_uri
      - post_logout_redirect_uri
    - op
      - authorization_endpoint
      - token_endpoint
      - jwkset_path
      - userinfo_endpoint
      - endsession_endpoint
      - issuer
    - claims
      - principal
      - groups
      - mail
- In spec add secureSettings
  - create a field called secretName with the name of the secret that contains your keycloak client secret
- Create a secret with the following data
  - xpack.security.authc.realms.oidc.${REALM_NAME}.rp.client_secret
- To enable oidc configuration you must have an enterprise license. To devlelop you can agree to the enterprise trial and have access to the features. To do so create the config map in eck_enterprise_trial.yaml


Most documentation you will see will reference xpack.security.authc.realms.oidc.oidc1, the oidc1 is the realm name, which is not always made clear.

## Add new groups

- Create elastic search role you want under system settings
- Create a role binding rule that matches the group name to the keycloak group

## Claim information

Sample Claim

```json
{
  "exp": 9999999999,
  "iat": 9999999999,
  "jti": "00000000-0000-0000-0000-000000000000",
  "iss": "https://keycloak.${dns}/auth/realms/{realm_name}",
  "sub": "00000000-0000-0000-0000-000000000000",
  "typ": "Bearer",
  "azp": "${client_id}",
  "session_state": "00000000-0000-0000-0000-000000000000",
  "acr": "1",
  "scope": "openid elastic",
  "groups": [
    "group_1",
    "...",
    "group_n"
  ],
  "preferred_username": "${username}",
  "email": "${email}"
}
```  
### Enabling Keycloak in Kibana

1. Get the elasticsearch user secret from the kubernetes secret
    - `kubectl get secrets -n elastic elasticsearch-es-elastic-user -o yaml | grep elastic: | awk '//{print $2}' | base64 -d`
2. log into kibana with elastic and the above password
3. Go to settings > Security > Role Mappings
4. Create the desired role 
    - For simplicity the following settings will make everyone a super user. Roles: Superuser, Mapping rules: groups = *
5. Apply the secret xpack.security.authc.realms.oidc.${REALM_NAME}.rp.client_secret with the correct value

6. These are the required updates to the default configuration of kibana

- in spec/config
  - add xpack.security.authc.providers
    - oidc.oidc1 (unlike elastic search it is always oidc.oidc1)
      - order (order choice will show up in the gui)
      - realm (keycloak realm name)

Adding the basic section will enable kibana login with elastic users (this is recommened to be removed after initial configuration)
 7. After applying the secret all of the nodes will do a rolling re-start (this takes about 10 minutes in testing).


## Dev Reference Resources

- [parent eck documentation](https://www.elastic.co/guide/en/cloud-on-k8s/1.2/index.html)
- [elastic secure settings](https://www.elastic.co/guide/en/cloud-on-k8s/1.2/k8s-es-secure-settings.html)
- [kibana configuration](https://www.elastic.co/guide/en/elasticsearch/reference/7.8/oidc-kibana.html)
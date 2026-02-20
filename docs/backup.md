# Snapshots and Data Resiliency

> **Prerequisites:**
> * ECK Operator installed and healthy.
> * Cloud storage bucket (S3/Azure/GCS) provisioned with appropriate IAM/Service Account permissions.
> * Kubernetes Secrets configured for keystore injection via `secureSettings`.

---

## 1. Architectural Overview
In the 9.x series, Elasticsearch utilizes **Snapshot Lifecycle Management (SLM)** to automate backups to cloud storage. This requires storage-specific plugins (e.g., `repository-s3`) to facilitate communication between the cluster and the storage provider.

---

## 2. Plugin Implementation
The current Iron Bank UBI-based image is pre-configured with the necessary directory permissions (`/usr/share/elasticsearch/plugins`) but does **not** include cloud storage plugins by default.

### Option A: Init-Container Installation
If the cluster has egress access to download binaries, you can install the plugin at runtime:

```yaml
initContainers:
- name: install-plugins
  command:
  - sh
  - -c
  - |
    bin/elasticsearch-plugin install --batch repository-s3
```

### Option B: Pre-Baked Image
Add the installation command to your downstream Dockerfile:
`RUN bin/elasticsearch-plugin install --batch repository-s3`

---

## 3. Security & Keystore
Credentials for cloud storage must be stored securely. Use a Kubernetes Secret to inject these into the Elasticsearch keystore via the `secureSettings` field in the Custom Resource.

---

## 4. Audit Checklist
* [ ] **Plugin Verification:** Run `GET /_cat/plugins?v` to ensure the storage plugin is active on all nodes.
* [ ] **Keystore Sync:** Verify `secureSettings` are mapped and nodes have reloaded settings.
* [ ] **SLM Policy:** Ensure the backup policy includes "Global State" to capture Kibana/Security configs.
* [ ] **Egress Check:** Ensure `NetworkPolicies` and Istio configurations allow pods to communicate with the storage endpoint (e.g., S3 API), see `bb-common` documentation for [Network Policies](https://repo1.dso.mil/big-bang/product/packages/bb-common/-/blob/main/docs/network-policies/README.md?ref_type=heads) and [Routes](https://repo1.dso.mil/big-bang/product/packages/bb-common/-/blob/main/docs/routes/README.md?ref_type=heads).

---

## 5. Official Documentation References
* [Elasticsearch 9.x Snapshot/Restore Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshot-restore.html)
* [ECK Snapshot Management](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-snapshots.html)
* [Big Bang Platform Documentation](https://repo1.dso.mil/platform-one/big-bang/bigbang)
* [bb-common helm library](https://repo1.dso.mil/big-bang/product/packages/bb-common/-/blob/main/docs/)
# Industry Adaptation Guide

## Overview
The `terraform-gcp-gke` module provisions a Google Kubernetes Engine cluster (Standard or Autopilot) with private cluster configuration, Workload Identity, Binary Authorization, Dataplane V2 (Cilium), Confidential Nodes, network policies, node auto-provisioning, vertical pod autoscaling, shielded nodes, custom node pools with GPU support, and Cloud Logging/Monitoring integration. Its security and scalability features serve any regulated or high-performance industry.

## Healthcare
### Compliance Requirements
- HIPAA, HITRUST, HL7 FHIR
### Configuration Changes
- Set `enable_private_cluster = true` and `enable_private_endpoint = true` to ensure cluster nodes and the API server are not internet-accessible.
- Configure `master_authorized_networks` to restrict API server access to known CIDR blocks.
- Set `enable_workload_identity = true` for IAM-based pod authentication without service account keys (HIPAA access controls).
- Set `enable_confidential_nodes = true` for hardware-encrypted memory protecting PHI during processing.
- Set `enable_binary_authorization = true` to ensure only signed, vetted container images run in the cluster.
- Set `enable_dataplane_v2 = true` for Cilium-based network policies separating clinical and administrative workloads.
- Use `node_pools` with `image_type = "COS_CONTAINERD"` and `auto_repair = true` for hardened, self-healing nodes.
- Set `logging_service = "logging.googleapis.com/kubernetes"` and `monitoring_service = "monitoring.googleapis.com/kubernetes"` for audit trails.
### Example Use Case
A digital health company runs its FHIR API on GKE with Confidential Nodes for in-memory PHI protection, Binary Authorization ensuring only approved images deploy, Workload Identity for secure access to Cloud Healthcare API, and Dataplane V2 for namespace isolation.

## Finance
### Compliance Requirements
- SOX, PCI-DSS, SOC 2
### Configuration Changes
- Set `enable_private_cluster = true` with `master_authorized_networks` limited to corporate CIDRs.
- Set `enable_binary_authorization = true` to enforce image provenance for CI/CD pipelines (PCI-DSS Requirement 6).
- Set `enable_dataplane_v2 = true` for L4/L7 network policy enforcement isolating CDE workloads.
- Set `enable_confidential_nodes = true` for memory encryption of financial transaction data.
- Configure `node_pools` with `preemptible = false` and `spot = false` for stable transaction processing.
- Set `enable_workload_identity = true` to eliminate service account key files (PCI-DSS Requirement 8).
- Set `release_channel = "STABLE"` for predictable, well-tested Kubernetes versions.
- Configure `maintenance_window` for off-hours to avoid impacting trading systems.
- Set `cluster_autoscaling` with appropriate CPU/memory limits for cost-controlled scaling.
### Example Use Case
A trading firm runs its order matching engine on GKE with Confidential Nodes, stable release channel, Binary Authorization enforcing signed images from its CI pipeline, and Dataplane V2 isolating trading workloads from market data services.

## Government
### Compliance Requirements
- FedRAMP, CMMC, NIST 800-53
### Configuration Changes
- Deploy in Assured Workloads-enabled projects for IL-4/IL-5 compliance.
- Set `enable_private_cluster = true` and `enable_private_endpoint = true` (NIST AC-17, SC-7).
- Set `enable_binary_authorization = true` for software supply chain integrity (NIST SI-7).
- Set `enable_confidential_nodes = true` for CUI protection in memory (NIST SC-28).
- Set `enable_workload_identity = true` for strong authentication (NIST IA-2).
- Set `enable_dataplane_v2 = true` for microsegmentation (NIST SC-7).
- Set `enable_network_policy = true` as additional network boundary enforcement.
- Configure `node_pools` with `image_type = "COS_CONTAINERD"` for CIS-benchmarked node images.
- Set `release_channel = "STABLE"` for validated Kubernetes versions.
### Example Use Case
A government contractor deploys an IL-4 workload on GKE in an Assured Workloads project with Confidential Nodes, private endpoints, Binary Authorization, and Dataplane V2, all monitored through Cloud Logging.

## Retail / E-Commerce
### Compliance Requirements
- PCI-DSS, CCPA/GDPR
### Configuration Changes
- Configure `node_pools` with varying `machine_type` sizes and autoscaling (`min_count` / `max_count`) for traffic spikes.
- Use `spot = true` node pools for non-critical batch workloads (recommendations, analytics).
- Set `enable_autopilot = true` for fully managed, per-pod billing to optimize costs.
- Set `enable_vertical_pod_autoscaling = true` for right-sizing application resources.
- Enable `cluster_autoscaling` (NAP) for automatic node provisioning during peak events.
- Set `enable_dataplane_v2 = true` for network policies separating payment services.
- Configure GPU-enabled node pools (`gpu_type`, `gpu_count`) for ML-based recommendation engines.
- Set `maintenance_window` to avoid peak shopping hours.
### Example Use Case
An e-commerce platform uses GKE Autopilot for its catalog and search services, spot node pools for recommendation model training, GPU nodes for real-time personalization inference, and Dataplane V2 isolating the checkout payment flow.

## Education
### Compliance Requirements
- FERPA, COPPA
### Configuration Changes
- Set `enable_private_cluster = true` to protect student data environments.
- Set `enable_workload_identity = true` for secure access to Cloud SQL and Cloud Storage containing student records.
- Set `enable_dataplane_v2 = true` for namespace isolation between student services and research workloads.
- Configure `node_pools` with `preemptible = true` for cost-effective research computing and `preemptible = false` for student-facing services.
- Set `enable_binary_authorization = true` to ensure only approved images run in student data environments.
- Set `logging_service` and `monitoring_service` for audit trails of access to FERPA-protected data.
### Example Use Case
A university runs its LMS and research computing platform on GKE with private endpoints, Workload Identity for secure database access, Dataplane V2 separating student and research namespaces, and preemptible nodes for cost-efficient research batch jobs.

## SaaS / Multi-Tenant
### Compliance Requirements
- SOC 2, ISO 27001
### Configuration Changes
- Use `node_pools` with `labels` and `taints` per tenant tier for workload isolation.
- Set `enable_workload_identity = true` so each tenant's pods authenticate to tenant-specific GCP resources.
- Set `enable_dataplane_v2 = true` for namespace-level network policy enforcement between tenants.
- Configure `cluster_autoscaling` (NAP) to auto-provision nodes based on tenant demand.
- Set `enable_vertical_pod_autoscaling = true` for optimal resource allocation per tenant.
- Set `enable_binary_authorization = true` for SOC 2 change management controls.
- Configure `maintenance_window` during agreed-upon maintenance periods per tenant SLAs.
- Set `release_channel = "REGULAR"` for balanced stability and feature availability.
### Example Use Case
A multi-tenant SaaS provider runs 300+ tenants on a shared GKE cluster with Dataplane V2 enforcing per-namespace network policies, Workload Identity mapping tenant pods to isolated GCS buckets and BigQuery datasets, and NAP auto-provisioning nodes during peak hours.

## Cross-Industry Best Practices
- Use environment-based configuration by parameterizing `cluster_name`, `project_id`, and `tags` per environment.
- Always enable encryption at rest (default with GKE) and in transit via `enable_private_cluster = true`.
- Enable comprehensive audit logging via `logging_service = "logging.googleapis.com/kubernetes"`.
- Enforce least-privilege access controls via `enable_workload_identity = true` and `master_authorized_networks`.
- Implement network segmentation via `enable_dataplane_v2 = true` for Cilium-based network policies.
- Configure backup and disaster recovery by deploying across multiple `zones` and using `release_channel = "STABLE"` for production clusters.

# terraform-gcp-gke

Production-ready Terraform module for provisioning Google Kubernetes Engine (GKE) clusters on Google Cloud Platform.

Supports both **Autopilot** and **Standard** cluster modes with the following production features:

- **Workload Identity** for secure pod-to-GCP-service authentication
- **Binary Authorization** for container image verification
- **Config Sync** readiness via Config Connector addon
- **Confidential Nodes** for memory encryption at the hardware level
- **Dataplane V2** (Cilium-based networking)
- **Network Policy** enforcement
- **Private clusters** with configurable master authorized networks
- **Cluster Autoscaling** (Node Auto-Provisioning)
- **Vertical Pod Autoscaling**
- **Shielded GKE Nodes** with secure boot and integrity monitoring
- **Maintenance windows** for controlled upgrade scheduling

## Usage

### Basic Standard Cluster

```hcl
module "gke" {
  source = "github.com/kogunlowo123/terraform-gcp-gke"

  project_id   = "my-project"
  cluster_name = "my-cluster"
  region       = "us-central1"
  zones        = ["us-central1-a", "us-central1-b", "us-central1-c"]

  network             = "my-vpc"
  subnetwork          = "my-subnet"
  pods_range_name     = "pods"
  services_range_name = "services"

  node_pools = [
    {
      name         = "default-pool"
      machine_type = "e2-standard-4"
      min_count    = 1
      max_count    = 5
      disk_size    = 100
      disk_type    = "pd-standard"
      preemptible  = false
      spot         = false
      image_type   = "COS_CONTAINERD"
      auto_repair  = true
      auto_upgrade = true
    }
  ]
}
```

### Autopilot Cluster

```hcl
module "gke" {
  source = "github.com/kogunlowo123/terraform-gcp-gke"

  project_id   = "my-project"
  cluster_name = "my-autopilot-cluster"
  region       = "us-central1"

  network             = "my-vpc"
  subnetwork          = "my-subnet"
  pods_range_name     = "pods"
  services_range_name = "services"

  enable_autopilot = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 5.10.0 |
| google-beta | >= 5.10.0 |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| project_id | GCP project ID | `string` | n/a |
| cluster_name | Name of the GKE cluster | `string` | n/a |
| region | GCP region | `string` | n/a |
| zones | List of zones for node placement | `list(string)` | `[]` |
| network | VPC network name | `string` | n/a |
| subnetwork | Subnetwork name | `string` | n/a |
| pods_range_name | Secondary range name for pods | `string` | n/a |
| services_range_name | Secondary range name for services | `string` | n/a |
| enable_autopilot | Enable Autopilot mode | `bool` | `false` |
| master_ipv4_cidr_block | CIDR block for the master network | `string` | `"172.16.0.0/28"` |
| enable_private_cluster | Enable private cluster | `bool` | `true` |
| enable_private_endpoint | Use private endpoint only | `bool` | `false` |
| master_authorized_networks | Authorized CIDR blocks for master access | `list(object)` | `[]` |
| kubernetes_version | Kubernetes version | `string` | `"latest"` |
| release_channel | Release channel (UNSPECIFIED, RAPID, REGULAR, STABLE) | `string` | `"REGULAR"` |
| node_pools | List of node pool configurations | `list(object)` | See variables.tf |
| enable_workload_identity | Enable Workload Identity | `bool` | `true` |
| enable_binary_authorization | Enable Binary Authorization | `bool` | `false` |
| enable_network_policy | Enable NetworkPolicy | `bool` | `true` |
| enable_dataplane_v2 | Enable Dataplane V2 | `bool` | `true` |
| enable_confidential_nodes | Enable Confidential Nodes | `bool` | `false` |
| cluster_autoscaling | Cluster autoscaling (NAP) configuration | `object` | See variables.tf |
| maintenance_window | Maintenance window configuration | `object` | See variables.tf |
| enable_vertical_pod_autoscaling | Enable VPA | `bool` | `true` |
| logging_service | Logging service endpoint | `string` | `"logging.googleapis.com/kubernetes"` |
| monitoring_service | Monitoring service endpoint | `string` | `"monitoring.googleapis.com/kubernetes"` |
| tags | Map of tags for all resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | Unique identifier of the cluster |
| cluster_name | Name of the cluster |
| cluster_endpoint | IP address of the cluster master (sensitive) |
| cluster_ca_certificate | Base64-encoded cluster CA certificate (sensitive) |
| cluster_location | Location of the cluster |
| cluster_self_link | Server-defined URL for the cluster |
| cluster_master_version | Current master version |
| node_pool_names | List of node pool names |
| node_pool_versions | Map of node pool names to versions |
| node_service_account_email | Email of the node service account |
| cluster_private_endpoint | Private IP of the master |
| cluster_public_endpoint | Public IP of the master |
| workload_identity_pool | Workload Identity pool identifier |

## Examples

- [Basic](./examples/basic/) - Minimal Standard cluster
- [Standard](./examples/standard/) - Production Standard cluster with all features
- [Autopilot](./examples/autopilot/) - Production Autopilot cluster

## License

MIT License. See [LICENSE](./LICENSE) for details.

###############################################################################
# Basic GKE Cluster Example
#
# This example creates a minimal Standard GKE cluster with default settings.
###############################################################################

module "gke" {
  source = "../../"

  project_id   = var.project_id
  cluster_name = "basic-gke-cluster"
  region       = "us-central1"
  zones        = ["us-central1-a", "us-central1-b", "us-central1-c"]

  network    = "default"
  subnetwork = "default"

  pods_range_name     = "pods"
  services_range_name = "services"

  master_ipv4_cidr_block = "172.16.0.0/28"

  enable_private_cluster  = true
  enable_private_endpoint = false

  kubernetes_version = "latest"
  release_channel    = "REGULAR"

  node_pools = [
    {
      name         = "default-pool"
      machine_type = "e2-standard-4"
      min_count    = 1
      max_count    = 3
      disk_size    = 100
      disk_type    = "pd-standard"
      preemptible  = false
      spot         = false
      image_type   = "COS_CONTAINERD"
      auto_repair  = true
      auto_upgrade = true
    }
  ]

  tags = {
    environment = "dev"
    example     = "basic"
  }
}

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

output "cluster_name" {
  value = module.gke.cluster_name
}

output "cluster_endpoint" {
  value     = module.gke.cluster_endpoint
  sensitive = true
}

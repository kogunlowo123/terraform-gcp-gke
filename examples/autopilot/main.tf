###############################################################################
# Autopilot GKE Cluster Example
#
# This example creates a production-grade GKE Autopilot cluster with Workload
# Identity and Binary Authorization enabled.
###############################################################################

module "gke" {
  source = "../../"

  project_id   = var.project_id
  cluster_name = "autopilot-prod-cluster"
  region       = "us-central1"

  network    = "prod-vpc"
  subnetwork = "prod-subnet"

  pods_range_name     = "pods"
  services_range_name = "services"

  master_ipv4_cidr_block = "172.16.0.0/28"

  enable_private_cluster  = true
  enable_private_endpoint = false

  master_authorized_networks = [
    {
      cidr_block   = "10.0.0.0/8"
      display_name = "Internal"
    }
  ]

  enable_autopilot = true

  kubernetes_version = "latest"
  release_channel    = "REGULAR"

  enable_workload_identity    = true
  enable_binary_authorization = true

  maintenance_window = {
    start_time = "2024-01-01T03:00:00Z"
    end_time   = "2024-01-01T07:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
  }

  tags = {
    environment = "production"
    team        = "platform"
    example     = "autopilot"
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

output "workload_identity_pool" {
  value = module.gke.workload_identity_pool
}

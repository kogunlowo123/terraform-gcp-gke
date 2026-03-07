###############################################################################
# Standard GKE Cluster Example
#
# This example creates a production-grade Standard GKE cluster with Workload
# Identity, Binary Authorization, Confidential Nodes, and multiple node pools.
###############################################################################

module "gke" {
  source = "../../"

  project_id   = var.project_id
  cluster_name = "standard-prod-cluster"
  region       = "us-central1"
  zones        = ["us-central1-a", "us-central1-b", "us-central1-c"]

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

  kubernetes_version = "latest"
  release_channel    = "REGULAR"

  enable_autopilot            = false
  enable_workload_identity    = true
  enable_binary_authorization = true
  enable_network_policy       = true
  enable_dataplane_v2         = true
  enable_confidential_nodes   = true

  enable_vertical_pod_autoscaling = true

  cluster_autoscaling = {
    enabled       = true
    min_cpu_cores = 4
    max_cpu_cores = 64
    min_memory_gb = 16
    max_memory_gb = 256
    gpu_resources = []
  }

  maintenance_window = {
    start_time = "2024-01-01T03:00:00Z"
    end_time   = "2024-01-01T07:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
  }

  node_pools = [
    {
      name         = "system-pool"
      machine_type = "n2d-standard-4"
      min_count    = 2
      max_count    = 5
      disk_size    = 100
      disk_type    = "pd-ssd"
      preemptible  = false
      spot         = false
      image_type   = "COS_CONTAINERD"
      auto_repair  = true
      auto_upgrade = true
      labels = {
        pool = "system"
      }
      taints = [
        {
          key    = "dedicated"
          value  = "system"
          effect = "NO_SCHEDULE"
        }
      ]
    },
    {
      name         = "app-pool"
      machine_type = "n2d-standard-8"
      min_count    = 3
      max_count    = 20
      disk_size    = 200
      disk_type    = "pd-ssd"
      preemptible  = false
      spot         = false
      image_type   = "COS_CONTAINERD"
      auto_repair  = true
      auto_upgrade = true
      labels = {
        pool = "applications"
      }
      taints = []
    },
    {
      name         = "spot-pool"
      machine_type = "n2d-standard-4"
      min_count    = 0
      max_count    = 10
      disk_size    = 100
      disk_type    = "pd-standard"
      preemptible  = false
      spot         = true
      image_type   = "COS_CONTAINERD"
      auto_repair  = true
      auto_upgrade = true
      labels = {
        pool = "spot"
      }
      taints = [
        {
          key    = "cloud.google.com/gke-spot"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  ]

  tags = {
    environment = "production"
    team        = "platform"
    example     = "standard"
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

output "node_pool_names" {
  value = module.gke.node_pool_names
}

output "workload_identity_pool" {
  value = module.gke.workload_identity_pool
}

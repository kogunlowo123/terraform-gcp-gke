module "test" {
  source = "../"

  project_id   = "test-project-id"
  cluster_name = "test-gke-cluster"
  region       = "us-central1"
  zones        = ["us-central1-a", "us-central1-b", "us-central1-c"]

  # Networking
  network              = "test-vpc-network"
  subnetwork           = "test-subnet"
  pods_range_name      = "pods"
  services_range_name  = "services"
  master_ipv4_cidr_block = "172.16.0.0/28"

  enable_private_cluster  = true
  enable_private_endpoint = false

  master_authorized_networks = [
    {
      cidr_block   = "10.0.0.0/8"
      display_name = "internal-network"
    }
  ]

  # Cluster mode
  enable_autopilot = false

  # Kubernetes version
  kubernetes_version = "latest"
  release_channel    = "REGULAR"

  # Node pools
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
      gpu_type     = ""
      gpu_count    = 0
      taints       = []
      labels       = {}
    }
  ]

  # Security
  enable_workload_identity     = true
  enable_binary_authorization  = false
  enable_network_policy        = true
  enable_dataplane_v2          = true
  enable_confidential_nodes    = false

  # Autoscaling
  cluster_autoscaling = {
    enabled       = false
    min_cpu_cores = 0
    max_cpu_cores = 0
    min_memory_gb = 0
    max_memory_gb = 0
    gpu_resources = []
  }

  maintenance_window = {
    start_time = "2024-01-01T05:00:00Z"
    end_time   = "2024-01-01T09:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
  }

  enable_vertical_pod_autoscaling = true

  # Logging & Monitoring
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  tags = {
    environment = "test"
    managed_by  = "terraform"
  }
}

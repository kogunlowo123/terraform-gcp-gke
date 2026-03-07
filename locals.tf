locals {
  cluster_name = var.cluster_name
  region       = var.region
  project_id   = var.project_id

  # Workload Identity pool
  workload_identity_pool = var.enable_workload_identity ? "${var.project_id}.svc.id.goog" : ""

  # Node service account email
  node_sa_email = google_service_account.gke_node_sa.email

  # Labels applied to cluster and node pools
  cluster_labels = merge(var.tags, {
    managed_by = "terraform"
    cluster    = var.cluster_name
  })

  # Master authorized CIDR blocks
  master_authorized_cidr_blocks = var.master_authorized_networks

  # Determine location: regional vs zonal
  location = var.region
  node_locations = length(var.zones) > 0 ? var.zones : null
}

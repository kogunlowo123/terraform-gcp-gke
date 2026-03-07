###############################################################################
# Cluster Outputs
###############################################################################

output "cluster_id" {
  description = "The unique identifier of the GKE cluster."
  value       = google_container_cluster.cluster.id
}

output "cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "The IP address of the GKE cluster master."
  value       = google_container_cluster.cluster.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The public certificate authority of the cluster (base64 encoded)."
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "The location (region or zone) of the cluster."
  value       = google_container_cluster.cluster.location
}

output "cluster_self_link" {
  description = "The server-defined URL for the cluster resource."
  value       = google_container_cluster.cluster.self_link
}

output "cluster_master_version" {
  description = "The current version of the master in the cluster."
  value       = google_container_cluster.cluster.master_version
}

###############################################################################
# Node Pool Outputs
###############################################################################

output "node_pool_names" {
  description = "List of node pool names in the cluster."
  value       = [for np in google_container_node_pool.node_pools : np.name]
}

output "node_pool_versions" {
  description = "Map of node pool names to their Kubernetes versions."
  value       = { for np in google_container_node_pool.node_pools : np.name => np.version }
}

###############################################################################
# Service Account Outputs
###############################################################################

output "node_service_account_email" {
  description = "The email of the GKE node service account."
  value       = google_service_account.gke_node_sa.email
}

output "node_service_account_id" {
  description = "The fully-qualified ID of the GKE node service account."
  value       = google_service_account.gke_node_sa.id
}

###############################################################################
# Networking Outputs
###############################################################################

output "cluster_private_endpoint" {
  description = "The private IP address of the cluster master (if private cluster is enabled)."
  value       = try(google_container_cluster.cluster.private_cluster_config[0].private_endpoint, "")
}

output "cluster_public_endpoint" {
  description = "The public IP address of the cluster master (if available)."
  value       = try(google_container_cluster.cluster.private_cluster_config[0].public_endpoint, "")
}

output "peering_name" {
  description = "The name of the peering between the cluster VPC and the Google services VPC."
  value       = try(google_container_cluster.cluster.private_cluster_config[0].peering_name, "")
}

###############################################################################
# Workload Identity
###############################################################################

output "workload_identity_pool" {
  description = "The Workload Identity pool for the cluster."
  value       = local.workload_identity_pool
}

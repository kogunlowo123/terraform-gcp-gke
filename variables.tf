###############################################################################
# Project & Location
###############################################################################

variable "project_id" {
  description = "The GCP project ID where the GKE cluster will be created."
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster."
  type        = string
}

variable "zones" {
  description = "The list of zones within the region for the cluster nodes."
  type        = list(string)
  default     = []
}

###############################################################################
# Networking
###############################################################################

variable "network" {
  description = "The VPC network to host the cluster in."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in."
  type        = string
}

variable "pods_range_name" {
  description = "The name of the secondary IP range for pods."
  type        = string
}

variable "services_range_name" {
  description = "The name of the secondary IP range for services."
  type        = string
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation for the hosted master network."
  type        = string
  default     = "172.16.0.0/28"
}

variable "enable_private_cluster" {
  description = "Whether to create a private cluster with nodes that have no public IP."
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Whether the master's internal IP address is used as the cluster endpoint."
  type        = bool
  default     = false
}

variable "master_authorized_networks" {
  description = "List of master authorized networks with CIDR blocks."
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = []
}

###############################################################################
# Cluster Mode
###############################################################################

variable "enable_autopilot" {
  description = "Whether to create an Autopilot cluster instead of a Standard cluster."
  type        = bool
  default     = false
}

###############################################################################
# Kubernetes Version & Release Channel
###############################################################################

variable "kubernetes_version" {
  description = "The Kubernetes version for the cluster master and nodes."
  type        = string
  default     = "latest"
}

variable "release_channel" {
  description = "The release channel for the cluster. Accepted values are UNSPECIFIED, RAPID, REGULAR, and STABLE."
  type        = string
  default     = "REGULAR"
}

###############################################################################
# Node Pools (Standard clusters only)
###############################################################################

variable "node_pools" {
  description = "List of node pool configurations for Standard clusters."
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size    = number
    disk_type    = string
    preemptible  = bool
    spot         = bool
    image_type   = string
    auto_repair  = bool
    auto_upgrade = bool
    gpu_type     = optional(string, "")
    gpu_count    = optional(number, 0)
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
    labels = optional(map(string), {})
  }))
  default = [
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
      gpu_type     = ""
      gpu_count    = 0
      taints       = []
      labels       = {}
    }
  ]
}

###############################################################################
# Security & Features
###############################################################################

variable "enable_workload_identity" {
  description = "Whether to enable Workload Identity on the cluster."
  type        = bool
  default     = true
}

variable "enable_binary_authorization" {
  description = "Whether to enable Binary Authorization for the cluster."
  type        = bool
  default     = false
}

variable "enable_network_policy" {
  description = "Whether to enable NetworkPolicy enforcement on the cluster."
  type        = bool
  default     = true
}

variable "enable_dataplane_v2" {
  description = "Whether to enable GKE Dataplane V2 (Cilium-based)."
  type        = bool
  default     = true
}

variable "enable_confidential_nodes" {
  description = "Whether to enable Confidential GKE Nodes."
  type        = bool
  default     = false
}

###############################################################################
# Autoscaling & Maintenance
###############################################################################

variable "cluster_autoscaling" {
  description = "Cluster-level autoscaling configuration (NAP)."
  type = object({
    enabled       = bool
    min_cpu_cores = optional(number, 0)
    max_cpu_cores = optional(number, 0)
    min_memory_gb = optional(number, 0)
    max_memory_gb = optional(number, 0)
    gpu_resources = optional(list(object({
      resource_type = string
      minimum       = number
      maximum       = number
    })), [])
  })
  default = {
    enabled       = false
    min_cpu_cores = 0
    max_cpu_cores = 0
    min_memory_gb = 0
    max_memory_gb = 0
    gpu_resources = []
  }
}

variable "maintenance_window" {
  description = "Maintenance window configuration for the cluster."
  type = object({
    start_time = string
    end_time   = string
    recurrence = string
  })
  default = {
    start_time = "2024-01-01T05:00:00Z"
    end_time   = "2024-01-01T09:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
  }
}

variable "enable_vertical_pod_autoscaling" {
  description = "Whether to enable Vertical Pod Autoscaling."
  type        = bool
  default     = true
}

###############################################################################
# Logging & Monitoring
###############################################################################

variable "logging_service" {
  description = "The logging service to use. Use logging.googleapis.com/kubernetes for Cloud Logging."
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "The monitoring service to use. Use monitoring.googleapis.com/kubernetes for Cloud Monitoring."
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

###############################################################################
# Tags
###############################################################################

variable "tags" {
  description = "A map of tags to apply to all resources."
  type        = map(string)
  default     = {}
}

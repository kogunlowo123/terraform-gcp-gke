data "google_project" "project" {
  project_id = var.project_id
}

data "google_compute_network" "network" {
  name    = var.network
  project = var.project_id
}

data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork
  region  = var.region
  project = var.project_id
}

data "google_container_engine_versions" "gke_versions" {
  project  = var.project_id
  location = var.region
}

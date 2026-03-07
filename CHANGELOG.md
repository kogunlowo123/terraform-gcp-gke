# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-01

### Added

- Initial release of the terraform-gcp-gke module.
- Support for GKE Standard clusters with configurable node pools.
- Support for GKE Autopilot clusters.
- Workload Identity integration for secure pod-to-GCP-service authentication.
- Binary Authorization support for container image verification.
- Config Sync readiness via Config Connector addon.
- Confidential GKE Nodes support for hardware-level memory encryption.
- Dataplane V2 (Cilium) networking support.
- Network Policy enforcement.
- Private cluster configuration with master authorized networks.
- Cluster Autoscaling (Node Auto-Provisioning) support.
- Vertical Pod Autoscaling support.
- Shielded GKE Nodes with secure boot and integrity monitoring.
- Configurable maintenance windows.
- Dedicated node service account with least-privilege IAM bindings.
- GPU node pool support with guest accelerators.
- Spot and preemptible VM support for node pools.
- Node pool taints and labels.
- Examples for basic, standard, and autopilot deployments.

# The core GKE Cluster Control Plane
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.zone

  network    = var.network_name
  subnetwork = var.subnet_name

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  # Enable Workload Identity for secure, keyless access from pods
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Cluster nodes have no public IP addresses
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # Can still run kubectl locally
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  # Control who can reach the public endpoint of the master nodes
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.master_authorized_cidr
      display_name = "Authorized External Access"
    }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = 1 # Keep at 1 for cost savings, enable autoscaling later

  node_config {
    machine_type = "e2-standard-2"

    # Ties node metadata to GKE Workload Identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
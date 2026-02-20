# The custom VPC
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  # Do not automatically create a subnet in every global region.
  auto_create_subnetworks = false
  project                 = var.project_id
}

# The single regional subnet
resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  project                  = var.project_id
  # Allow private GKE nodes to securely reach GCP services.
  private_ip_google_access = true
}

# Cloud Router required for the NAT Gateway
resource "google_compute_router" "router" {
  name    = "${var.network_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
}

# Cloud NAT to allow private nodes to reach the public internet for updates/packages
resource "google_compute_router_nat" "nat" {
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  project                            = var.project_id
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
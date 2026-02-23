data "google_client_config" "default" {}

# Call the VPC module
module "vpc" {
  source = "../../modules/vpc"

  project_id   = var.project_id
  region       = var.region
  network_name = "capstone-dev-vpc"
  subnet_name  = "capstone-dev-subnet"
  subnet_cidr  = "10.0.0.0/16"

  # Added to trigger tfsec pipeline
  # environment = "dev"

  # Wait for the APIs to be enabled before creating the VPC
  depends_on = [
    google_project_service.enabled_apis
  ]
}

module "gke" {
  source = "../../modules/gke"

  project_id   = var.project_id
  zone         = var.zone
  cluster_name = "capstone-dev-cluster"
  
  # Pass the network identifiers from the VPC module outputs
  network_name = module.vpc.network_name
  subnet_name  = module.vpc.subnet_name

  # Added to trigger tfsec pipeline
  # environment = "dev" 

  # Wait for the VPC to be fully built before trying to put a cluster inside it
  depends_on = [
    module.vpc
  ]
}
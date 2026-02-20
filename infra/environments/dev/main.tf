data "google_client_config" "default" {}

# Call the VPC module
module "vpc" {
  source = "../../modules/vpc"

  project_id   = var.project_id
  region       = var.region
  network_name = "capstone-dev-vpc"
  subnet_name  = "capstone-dev-subnet"
  subnet_cidr  = "10.0.0.0/16"

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

  # Wait for the VPC to be fully built before trying to put a cluster inside it
  depends_on = [
    module.vpc
  ]
}

module "wif" {
  source = "../../modules/wif"

  project_id        = var.project_id
  github_repository = var.github_repository

  depends_on = [
    google_project_service.enabled_apis
  ]
}

# Output the WIF details for use in CI/CD pipeline
output "github_actions_provider_name" {
  value = module.wif.provider_name
}

output "github_actions_service_account" {
  value = module.wif.service_account_email
}
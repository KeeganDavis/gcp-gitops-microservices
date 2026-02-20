data "google_client_config" "default" {}

# Call the VPC module
module "vpc" {
  source = "../../modules/vpc"

  project_id   = var.project_id
  region       = var.region
  network_name = "gcp-gitops-dev-vpc"
  subnet_name  = "gcp-gitops-dev-subnet"
  subnet_cidr  = "10.0.0.0/16"

  # Wait for the APIs to be enabled before creating the VPC
  depends_on = [
    google_project_service.enabled_apis
  ]
}
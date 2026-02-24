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

# OTel collector service account
resource "google_service_account" "otel_sa" {
  account_id   = "otel-collector-sa"
  display_name = "OpenTelemetry Collector Service Account"
}

# Grant OTel collector SA permission to write to Google Cloud Trace
resource "google_project_iam_member" "otel_trace_agent" {
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.otel_sa.email}"
}

# Bind the SA to the Kubernetes Service Account via Workload Identity
# member format: serviceAccount:PROJECT_ID.svc.id.goog[K8S_NAMESPACE/K8S_SERVICE_ACCOUNT]
resource "google_service_account_iam_member" "otel_workload_identity_binding" {
  service_account_id = google_service_account.otel_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[monitoring/otel-collector-ksa]"
}

# Output email for use in K8s manifests
output "otel_service_account_email" {
  value = google_service_account.otel_sa.email
}

# Reserve a static global IP address for the Python API Ingress
resource "google_compute_global_address" "python_api_ip" {
  name         = "python-api-global-ip"
  description  = "Static IP for the Capstone Python API"
  address_type = "EXTERNAL"
}

# Output the raw IP address
output "python_api_public_ip" {
  value       = google_compute_global_address.python_api_ip.address
  description = "The public IP address of the Python API"
}

# Output the name to use for the Ingress annotation in Helm template
output "python_api_ip_name" {
  value       = google_compute_global_address.python_api_ip.name
  description = "The name of the static IP resource"
}
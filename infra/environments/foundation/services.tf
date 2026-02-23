variable "gcp_service_list" {
  description = "The list of apis necessary for the project"
  type        = list(string)
  default = [
    "artifactregistry.googleapis.com",     # Required for Docker Images
    "iamcredentials.googleapis.com",       # Required for Workload Identity Federation
    "sts.googleapis.com"                   # Required for Security Token Service (WIF)
  ]
}

# Enable all APIs listed above
resource "google_project_service" "enabled_apis" {
  for_each = toset(var.gcp_service_list)

  project = var.project_id
  service = each.key

  # Prevents Terraform from destroying the API and dependent resources on destroy
  disable_on_destroy         = false
  disable_dependent_services = false
}
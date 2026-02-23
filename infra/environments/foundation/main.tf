module "wif" {
  source = "../../modules/wif"
  
  project_id        = var.project_id
  github_repository = var.github_repository
  
  pool_name     = "github-actions-pool-v2"
  provider_name = "github-provider-v2"
  sa_name       = "github-actions-sa-v2"

  depends_on = [google_project_service.enabled_apis]
}

module "gar" {
  source = "../../modules/gar"

  project_id    = var.project_id
  region        = var.region
  repository_id = "capstone-docker-repo"

  depends_on = [google_project_service.enabled_apis]
}

output "github_actions_provider_name" { value = module.wif.provider_name }
output "github_actions_service_account" { value = module.wif.service_account_email }
output "artifact_registry_url" { value = module.gar.repository_url }
# Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = var.pool_name
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for automated CI/CD"
}

# OIDC Provider for GitHub Actions
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = var.provider_name
  display_name                       = "GitHub OIDC Provider"

  # Map GitHub's JWT claims to GCP attributes so we can use them in IAM conditions
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  # Only allow tokens originating from the chosen GitHub repository
  attribute_condition = "assertion.repository == '${var.github_repository}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Dedicated CI/CD Service Account
resource "google_service_account" "github_actions_sa" {
  project      = var.project_id
  account_id   = var.sa_name
  display_name = "GitHub Actions Service Account"
  description  = "Impersonated by GitHub Actions to deploy infrastructure and code"
}

# Bind the GitHub Repository Identity to the Service Account
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_repository}"
}

# Grant Permissions to the Service Account to push Docker images and deploy to GKE
resource "google_project_iam_member" "sa_artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_project_iam_member" "sa_gke_developer" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}
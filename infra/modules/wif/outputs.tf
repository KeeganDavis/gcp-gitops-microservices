output "provider_name" {
  value       = google_iam_workload_identity_pool_provider.github_provider.name
  description = "The exact URI of the WIF provider needed for GitHub Actions"
}

output "service_account_email" {
  value       = google_service_account.github_actions_sa.email
  description = "The email of the Service Account GitHub Actions will impersonate"
}
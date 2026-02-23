output "repository_name" {
  value       = google_artifact_registry_repository.registry.name
  description = "The full name of the repository"
}

output "repository_url" {
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
  description = "The URL to push Docker images to"
}
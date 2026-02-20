variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "github_repository" {
  type        = string
  description = "The GitHub repository allowed to authenticate (format: 'username/repo-name')"
}

variable "pool_name" {
  type        = string
  description = "The name of the Workload Identity Pool"
  default     = "github-actions-pool"
}

variable "provider_name" {
  type        = string
  description = "The name of the Workload Identity Provider"
  default     = "github-provider"
}

variable "sa_name" {
  type        = string
  description = "The name of the Service Account for CI/CD"
  default     = "github-actions-sa"
}
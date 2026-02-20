variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "region" {
  description = "The default GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The default GCP zone for resources"
  type        = string
  default     = "us-central1-a"
}

variable "github_repository" {
  type        = string
  description = "The name of the GitHub repo"
}
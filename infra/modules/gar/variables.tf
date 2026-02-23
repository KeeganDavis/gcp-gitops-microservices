variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region for the registry"
}

variable "repository_id" {
  type        = string
  description = "The name of the repository (e.g., 'capstone-repo')"
}

variable "format" {
  type        = string
  description = "The format of packages stored in the repository"
  default     = "DOCKER"
}

variable "description" {
  type        = string
  description = "Description of the Artifact Registry repository"
  default     = "Docker repository for Capstone Project"
}
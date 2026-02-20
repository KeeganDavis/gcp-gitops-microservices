variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "zone" {
  type        = string
  description = "The GCP zone for the cluster (using a zone instead of a region saves 3x the cost for testing)"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "network_name" {
  type        = string
  description = "The VPC network to host the cluster in"
}

variable "subnet_name" {
  type        = string
  description = "The subnetwork to host the cluster in"
}

variable "master_authorized_cidr" {
  type        = string
  description = "The IP range permitted to access the cluster control plane"
  default     = "0.0.0.0/0" 
}
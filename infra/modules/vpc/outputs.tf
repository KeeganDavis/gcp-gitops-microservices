output "network_name" {
  value       = google_compute_network.vpc.name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.vpc.self_link
  description = "The URI of the VPC being created"
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "The name of the subnet being created"
}

output "subnet_self_link" {
  value       = google_compute_subnetwork.subnet.self_link
  description = "The URI of the subnet being created"
}
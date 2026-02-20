output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "The name of the provisioned cluster"
}

output "cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "The IP address of the cluster control plane"
}
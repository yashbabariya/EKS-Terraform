// EKS cluster
output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.EKS-cluster.cluster_endpoint
}
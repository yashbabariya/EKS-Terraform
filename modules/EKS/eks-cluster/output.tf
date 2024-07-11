output "cluster_endpoint" {
  value = aws_eks_cluster.services.endpoint
}

output "oidc_url" {
  description = "AWS IAM OIDC issuer url"
  value = aws_eks_cluster.services.identity[0].oidc[0].issuer
}

output "cluster_id" {
  value = aws_eks_cluster.services.name
}
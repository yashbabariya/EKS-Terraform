output "eks-cluster-role-arn" {
  description = "EKS cluster IAM role ARN"
  value = aws_iam_role.eks-cluster-role.arn
}

output "node-group-role-arn" {
  description = "EKS Node Grioup IAM role ARN"
  value = aws_iam_role.node-group-role.arn
}
variable "cluster_name" {
  type = string
  description = "EKS Cluster Name"
}

variable "oidc_url" {
  type = string
  description = "AWS IAM OIDC issuer url"
}
variable "cluster_name" {
  type = string
  description = "EKS cluster Name"
}

variable "oidc_connector_arn" {
  type = string
  description = "AWS IAM OIDC connect provider ARN"
}

variable "vpc_id" {
  type = string
  description = "AWS VPC Id"
}
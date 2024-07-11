variable "cluster_name" {
  type = string
  description = "EKS cluster Name"
}

variable "oidc_connector_arn" {
  type = string
  description = "AWS IAM OIDC connect provider ARN"
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}
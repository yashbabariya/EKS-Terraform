variable "region" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

// root user
variable "namespace" {
  type = string
}

variable "chart_version" {
  type        = string
  description = "MongoDB helm chart version."
}

variable "username" {
  type = string
  description = "Auth username"
}

variable "password" {
  type = string
  description = "Auth user password"
}

variable "communityplugins" {
  type = string
  description = "communityPlugins List of Community plugins (URLs) to be downloaded during container initialization"
}

variable "extraplugins" {
  type = string
  description = "extraPlugins Extra plugins to enable"
}

variable "persistence_size" {
  type        = string
  description = "Master Persistence size"
}

variable "storage_class" {
  type        = string
  description = "PVC storage class"
}

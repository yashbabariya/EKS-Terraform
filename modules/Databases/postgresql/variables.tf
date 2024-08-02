variable "region" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

// root user
variable "postgresPassword" {
  type        = string
  description = "Postgresql root user password"
}

variable "namespace" {
  type = string
}

variable "chart_version" {
  type        = string
  description = "MongoDB helm chart version."
}

variable "persistence_size" {
  type        = string
  description = "Persistence size"
}

variable "storage_class" {
  type        = string
  description = "PVC storage class"
}
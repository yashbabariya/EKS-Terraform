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

variable "master_persistence_size" {
  type        = string
  description = "Master Persistence size"
}

variable "storage_class" {
  type        = string
  description = "PVC storage class"
}

variable "replica_persistence_size" {
  type = string
  description = "Replicas Persistence size"
}


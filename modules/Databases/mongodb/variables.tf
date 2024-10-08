variable "region" {
  type = string
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

// root user
variable "rootuser_name" {
  type = string
  description = "RootUser name"
}

variable "rootpassword" {
  type        = string
  description = "Postgresql root user password"
}

variable "namespace" {
  type = string
}

variable "architecture" {
  type = string
  description = "architecture MongoDB architecture (`standalone` or `replicaset`)"
}

variable "replicacount" {
  type = string
  description = "the number of replicas is taken in account"
}

variable "service_type" {
  type = string
  description = "Kubernetes Service type"
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
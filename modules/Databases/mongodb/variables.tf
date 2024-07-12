variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
  description = "EKS Cluster name"
}

// root user
variable "rootuser_name" {
  type = string
  description = "MongoDB Root User name"
}

variable "rootpassword" {
  type = string
  description = "MongoDB root user password"
}

variable "namespace" {
  type = string
}

variable "replicacount" {
  type = number
    description = "replicaCount Number of MongoDB nodes"
}

variable "chart_version" {
  type = string
  description = "MongoDB helm chart version."
}

variable "persistence_size" {
  type = string
  description = "Persistence size"
}

variable "service_type" {
    type = string
    description = "Kubernetes Service type"
}

variable "storage_class" {
  type = string
  description = "PVC storage class"
}
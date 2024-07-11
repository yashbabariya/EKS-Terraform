// vpc 
variable "natgateway_public_ip" {
  type = string
}

variable "public_subnet" {
  type = list(string)
}

variable "private_subnet" {
  type = list(string)
}


// eks cluster
variable "region" {
  type    = string
}

variable "cluster_name" {
  type    = string
}

variable "my_ip" {
  type  = list(string)
}

variable "ports" {
  type    = list(number)
  default = [443]
}

variable "eks-cluster-role-arn" {
  type = string
  description = "EKS Cluster IAM Role ARN"
} 
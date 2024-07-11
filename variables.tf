// VPC
variable "region" {
  type        = string
  description = "aws region"
}

variable "availability_zone" {
  type        = list(string)
  description = "availability zone"
}

variable "name" {
  type        = string
  description = "Name of VPC, subnet, IGW, NAT, and Routetables"
}

variable "cidr_vpc" {
  type        = string
  description = "VPC cidr"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Puvlic Subnet CIDR"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnete CIDR"
}

// EKS clsuter

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "my_ip" {
  type        = list(string)
  description = "Enter your Office IP's"
}

// EKS node-group

variable "instance_types" {
  type        = string
  description = "node-group instance type"
}

variable "nodegroup_desired_size" {
  type        = number
  description = "node group scaling desired size"
}

variable "nodegroup_max_size" {
  type        = number
  description = "node group scaling max size"
}

variable "nodegroup_min_size" {
  type        = number
  description = "node group scaling min size"
}

// EBS-CSI Driver Add-on

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}
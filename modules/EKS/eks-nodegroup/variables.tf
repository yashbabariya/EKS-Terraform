// vpc 

# variable "public_subnet" {
#   type = list(string)
# }

variable "private_subnet" {
  type = list(string)
}

// eks cluster
variable "cluster_name" {
  type    = string
}

// node-group

variable "nodegroup_role_arn" {
  type = string
  description = "EKS Node Group IAM Role"
}

variable "instance_types" {
  type = string
  description = "node-group instance type"
}

variable "nodegroup_desired_size" {
  type = number
  description = "node group scaling desired size"
}

variable "nodegroup_max_size" {
  type = number
  description = "node group scaling max size"
}

variable "nodegroup_min_size" {
  type = number
  description = "node group scaling min size"
}

variable "ssh_key_name" {
  type = string
  description = "ssh-key name"
}
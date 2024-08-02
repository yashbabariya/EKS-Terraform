// vpc 
variable "vpc_id" {
  type = string
}

variable "natgateway_public_ip" {
  type = string
}

// eks cluster
variable "cluster_name" {
  type    = string
}

variable "ports" {
  type    = list(number)
  default = [443,22]
}

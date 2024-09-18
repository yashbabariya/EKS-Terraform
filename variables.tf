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

variable "nodegroup_ssh_key_name" {
  type        = string
  description = "NodeGroup Instance SSH Key name"
}

// EBS-CSI Driver Add-on

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))
}

// Global Database values
variable "global_storageclass" {
  type        = string
  description = "PVC StorageClass name"
}


// MongoDB Databases

variable "mongodb_namespace" {
  type        = string
  description = "database deployment namespace name"
}

variable "mongodb_rootuser_name" {
  type        = string
  description = "MongoDB RootUser name"
}

variable "mongodb_architecture" {
  type        = string
  description = "architecture MongoDB architecture (`standalone` or `replicaset`)"
}


variable "mongodb_rootuser_password" {
  type        = string
  description = "MongoDB RootUser password."
}

variable "replicacount" {
  type        = number
  description = "replicaCount Number of MongoDB nodes"
}

variable "mongodb_persistence_size" {
  type        = string
  description = "MongoDB Persistence size"
}

variable "mongodb_service_type" {
  type        = string
  description = "Kubernetes Service type"
}

variable "mongodb_chart_version" {
  type        = string
  description = "MongoDB helm chart version"
}

// Postgresql

variable "postgresql_namespace" {
  type        = string
  description = "Postgresql deployment namespace name"
}

variable "postgresql_password" {
  type        = string
  description = "Postgresql password"
}

variable "postgresql_chart_version" {
  type        = string
  description = "Postgresql helm chart version."
}

variable "postgresql_persistence_size" {
  type        = string
  description = "postgresql Persistence Size"
}


// Redis

variable "redis_namespace" {
  type        = string
  description = "Redis Deployment namespace name"
}

variable "redis_chart_version" {
  type        = string
  description = "Redis helm chart version."
}

variable "redis_master_persistence_size" {
  type        = string
  description = "Redis master Persistence size"
}

variable "redis_replicas_persistence_size" {
  type        = string
  description = "Redis replicas persistence size"
}

// RabbitMq 
variable "rabbitmq_chart_version" {
  type        = string
  description = "Rabbitmq helm chart version."
}

variable "rabbitmq_namespace" {
  type        = string
  description = "Rabbitmq deployment namespace name"
}

variable "rabbitmq_username" {
  type        = string
  description = "Rabbitmq Auth username"
}

variable "rabbitmq_password" {
  type        = string
  description = "Rabbitmq Auth user password "
}

variable "rabbitmq_communityplugins" {
  type        = string
  description = "communityPlugins List of Community plugins (URLs) to be downloaded during container initialization"
}

// default plugin name:- rabbitmq_auth_backend_ldap
variable "rabbitmq_extraplugins" {
  type        = string
  description = "extraPlugins Extra plugins to enable"
}

variable "rabbitmq_persistence_size" {
  type        = string
  description = "Rabbitmq PVC persistence size"
}


// Cockroach
variable "aws_launch_template_image_id" {
  type        = string
  description = "AWS launch template image_id"
}

variable "aws_launch_template_instance_type" {
  type        = string
  description = "AWS launch template instance_type."
}

variable "aws_autoscaling_group_name" {
  type        = string
  description = "AWS Autoscaling Group name"
}

variable "ami_name" {
  type        = string
  description = "AMI name"
}

variable "key_pair_name" {
  type        = string
  description = "ssh key pair name"
}

variable "target_group_ports" {
  type        = set(string)
  description = "Target group ports"
}

variable "gitlab_instance_ip" {
  type        = string
  description = "Gitlab Instance Public IP"
}
variable "vpc_id" {
  type        = string
  description = "AWS VPC network id"
}

variable "aws_launch_template_image_id" {
  type        = string
  description = "AWS launch template image_id"
}

variable "aws_launch_template_instance_type" {
  type        = string
  description = "AWS launch template instance_type."
}

variable "asg_security_group_id" {
  type        = string
  description = "EC2 instance template Security-group id"
}

variable "lb_security_group_id" {
  type        = string
  description = "ALB security group id"
}

variable "aws_autoscaling_group_name" {
  type        = string
  description = "AWS autoscaling group name"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "subnet Ids"
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


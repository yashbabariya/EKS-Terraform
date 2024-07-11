region = "<region>"

// VPC
name                = "<name>"
cidr_vpc            = "<vpc_cidr_range>"
cidr_public_subnet  = [<public_subnet_cidr_range>]
cidr_private_subnet = [<private_subnet_cidr_range>]
availability_zone   = [<availability_zones>]

// EKS cluster 
cluster_name = "<eks_cluster_name>"
my_ip        = [<your_network_ip>]

// Node Group
instance_types         = "<instance_type>"
nodegroup_desired_size = 
nodegroup_max_size     = 
nodegroup_min_size     = 

// EBS-CSI Driver Add-on

addons = [
  {
    name    = "<addon_name>"
    version = "<addon_version>"
  },
  {
    name    = "<addon_name>"
    version = "<addon_version>"
  },
  {
    name    = "<addon_name>"
    version = "<addon_version>"
  },
  {
    name    = "<addon_name>"
    version = "<addon_version>"
  },
  {
    name    = "<addon_name>"
    version = "<addon_version>"
  }
]
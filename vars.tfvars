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
instance_types         = "t2.xlarge"
nodegroup_desired_size = 2
nodegroup_max_size     = 2
nodegroup_min_size     = 2
nodegroup_ssh_key_name = "<key-name>"

// EBS-CSI Driver Add-on

addons = [
  {
    name    = "kube-proxy"
    version = "v1.28.8-eksbuild.5"
  },
  {
    name    = "vpc-cni"
    version = "v1.18.2-eksbuild.1"
  },
  {
    name    = "coredns"
    version = "v1.10.1-eksbuild.11"
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.32.0-eksbuild.1"
  },
  {
    name    = "eks-pod-identity-agent"
    version = "v1.3.0-eksbuild.1"
  }
]

// Global Databases values
global_storageclass = "gp2"

// Mongodb 
mongodb_namespace         = "default"
mongodb_rootuser_name     = "<username>"
mongodb_rootuser_password = "<password>"
mongodb_architecture      = "replicaset"
replicacount              = 1
mongodb_chart_version     = "15.6.12"
mongodb_persistence_size  = "2Gi"
mongodb_service_type      = "LoadBalancer"


// Postgresql
postgresql_chart_version    = "15.5.17"
postgresql_namespace        = "default"
postgresql_password         = "<password>"
postgresql_persistence_size = "2Gi"

//redis
redis_chart_version             = "19.6.2"
redis_namespace                 = "default"
redis_master_persistence_size   = "3Gi"
redis_replicas_persistence_size = "3Gi"

//rabbitmq
rabbitmq_chart_version    = "14.6.1"
rabbitmq_namespace        = "default"
rabbitmq_username         = "<username>"
rabbitmq_password         = "<password>"
rabbitmq_persistence_size = "3Gi"
rabbitmq_communityplugins = "https://github.com/rabbitmq/rabbitmq-delayed-message-exchange/releases/download/3.10.0/rabbitmq_delayed_message_exchange-3.10.0.ez"
rabbitmq_extraplugins     = "rabbitmq_delayed_message_exchange"
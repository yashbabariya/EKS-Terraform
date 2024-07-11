module "vpc" {
  source              = "./modules/vpc"
  region              = var.region
  name                = var.name
  cidr_vpc            = var.cidr_vpc
  cidr_private_subnet = var.cidr_private_subnet
  cidr_public_subnet  = var.cidr_public_subnet
  availability_zone   = var.availability_zone
}

module "security_group" {
  source               = "./modules/EKS/security-group"
  natgateway_public_ip = module.vpc.nat_gateway_public_ip
  cluster_name         = var.cluster_name
  vpc_id               = module.vpc.vpc_id
  depends_on           = [module.vpc]
}

module "IAM" {
  source       = "./modules/IAM"
  cluster_name = var.cluster_name
  depends_on   = [module.security_group]
}

module "EKS-cluster" {
  source               = "./modules/EKS/eks-cluster"
  cluster_name         = var.cluster_name
  region               = var.region
  eks-cluster-role-arn = module.IAM.eks-cluster-role-arn
  natgateway_public_ip = module.vpc.nat_gateway_public_ip
  public_subnet        = module.vpc.public_subnet_id
  private_subnet       = module.vpc.private_subnet_id
  my_ip                = var.my_ip
  depends_on           = [module.IAM]
}

data "aws_eks_cluster" "cluster" {
  name       = module.EKS-cluster.cluster_id
  depends_on = [module.EKS-cluster]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.EKS-cluster.cluster_id
  depends_on = [module.EKS-cluster]
}

// Authenticate AWS EKS cluster with helm
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

// Authenticate AWS EKS cluster
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "IAM-oidc-provider" {
  source       = "./modules/EKS/iam-oidc-provider"
  cluster_name = var.cluster_name
  oidc_url     = module.EKS-cluster.oidc_url
  depends_on   = [module.EKS-cluster]
}

module "EKS-nodegroup" {
  source       = "./modules/EKS/eks-nodegroup"
  cluster_name = var.cluster_name
  # public_subnet = module.vpc.public_subnet_id
  private_subnet         = module.vpc.private_subnet_id
  nodegroup_max_size     = var.nodegroup_desired_size
  nodegroup_min_size     = var.nodegroup_min_size
  nodegroup_desired_size = var.nodegroup_desired_size
  nodegroup_role_arn     = module.IAM.node-group-role-arn
  instance_types         = var.instance_types
  depends_on             = [module.EKS-cluster, module.IAM]
}

module "ALB-controller" {
  source             = "./modules/EKS/alb-controller"
  oidc_connector_arn = module.IAM-oidc-provider.oidc_connector_arn
  cluster_name       = var.cluster_name
  depends_on         = [module.EKS-nodegroup]
  vpc_id = module.vpc.vpc_id
}

module "EBS-csi-driver" {
  source             = "./modules/EKS/ebs-csi-driver"
  cluster_name       = var.cluster_name
  oidc_connector_arn = module.IAM-oidc-provider.oidc_connector_arn
  addons             = var.addons
  depends_on         = [module.EKS-nodegroup, module.ALB-controller]
}
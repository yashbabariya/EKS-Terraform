// EKS Node Group

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.nodegroup_role_arn
  instance_types  = [var.instance_types] # "# cpu=2, memory=8Gi, pod=35

  subnet_ids = [
    var.private_subnet[0],
    var.private_subnet[1],
    var.private_subnet[2]
  ]

  scaling_config {
    desired_size = var.nodegroup_desired_size
    max_size     = var.nodegroup_max_size
    min_size     = var.nodegroup_min_size
  }

  update_config {
    max_unavailable = 1
  }
}


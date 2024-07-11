# create new eks-cluster in public subnet
resource "aws_eks_cluster" "services" {
  name     = var.cluster_name
  role_arn = var.eks-cluster-role-arn

  vpc_config {
    subnet_ids = [
      var.public_subnet[0],
      var.public_subnet[1],
      var.public_subnet[2],
      var.private_subnet[0],
      var.private_subnet[1],
      var.private_subnet[2]
    ]
    endpoint_public_access  = true
    endpoint_private_access = true

    public_access_cidrs = ["${var.natgateway_public_ip}/32", var.my_ip[0], var.my_ip[1]]

  }

  # access_config {
  #   authentication_mode = "API_AND_CONFIG_MAP"
  #   bootstrap_cluster_creator_admin_permissions = true
  # }
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${aws_eks_cluster.services.name} --region ${var.region}"
  }
  depends_on = [aws_eks_cluster.services]
}



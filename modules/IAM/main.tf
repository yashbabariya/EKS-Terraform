# create new role for EKS-cluster
resource "aws_iam_role" "eks-cluster-role" {
  name       = "${var.cluster_name}-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
EOF

}

# Attachment policy to the eks-cluster role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
  depends_on = [aws_iam_role.eks-cluster-role]
}

# enable Security Groups for Pods
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
  depends_on = [aws_iam_role.eks-cluster-role]
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Cretae EKS Node-group Roles.
resource "aws_iam_role" "node-group-role" {
  name       = "${var.cluster_name}-node-group-role"

  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
            "Statement": [
                    {
                    "Effect": "Allow",
                    "Principal": {
                        "Service": "ec2.amazonaws.com"
                    },
                    "Action": "sts:AssumeRole"
                }
            ]
        }
    EOF
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node-group-role.name
  depends_on = [aws_iam_role.node-group-role]
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node-group-role.name
  depends_on = [aws_iam_role.node-group-role]
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node-group-role.name
  depends_on = [aws_iam_role.node-group-role]
}


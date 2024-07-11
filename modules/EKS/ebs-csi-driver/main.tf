
data "http" "AmazonEKS_EBS_CSI_Driver_Policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v1.0.0/docs/example-iam-policy.json"
  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "AmazonEKS_EBS_CSI_Driver_Policy" {
  name        = "${var.cluster_name}-AmazonEKS_EBS_CSI_Driver_Policy"
  path        = "/"
  description = "AWS EBS CSI controller IAM policy"
  policy      = data.http.AmazonEKS_EBS_CSI_Driver_Policy.response_body
}

# Create an IAM Role 
resource "aws_iam_role" "ebs-iam-role" {
  name = "${var.cluster_name}-ebs-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${var.oidc_connector_arn}"
        }
        Condition = {
          StringEquals = {
            "${element(split("oidc-provider/", "${var.oidc_connector_arn}"), 1)}:aud" : "sts.amazonaws.com",
            "${element(split("oidc-provider/", "${var.oidc_connector_arn}"), 1)}:sub" : "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.cluster_name}-ebs-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_EBS_CSI_Driver_Policy-attachment" {
  policy_arn = aws_iam_policy.AmazonEKS_EBS_CSI_Driver_Policy.arn
  role       = aws_iam_role.ebs-iam-role.name
}

# Create Service account of aws-load-balancer-controller
resource "kubernetes_service_account" "zuru-ebs-csi-controller-sa" {
  depends_on = [aws_iam_role.ebs-iam-role]
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ebs-iam-role.arn
    }

    labels = {
      "app.kubernetes.io/name" = "ebs-csi-controller-sa"
    }
  }
}

# Attach CNI plugin for kubernetes.
resource "aws_eks_addon" "eks-addon" {
  for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = var.cluster_name
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts_on_update = "PRESERVE"
  resolve_conflicts_on_create = "OVERWRITE"
  depends_on        = [kubernetes_service_account.zuru-ebs-csi-controller-sa]
}

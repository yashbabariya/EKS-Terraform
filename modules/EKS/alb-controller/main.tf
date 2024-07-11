
# Download an IAM policy for the AWS Load Balancer Controller
data "http" "AWSLoadBalancerControllerIAMPolicy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json"

  request_headers = {
    Accept = "application/json"
  }
}

data "http" "AWSLoadBalancerControllerAdditionalIAMPolicy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy_v1_to_v2_additional.json"
  request_headers = {
    Accept = "application/json"
  }
}

data "aws_iam_openid_connect_provider" "oidc-connector" {
  arn = var.oidc_connector_arn
}

locals {
  aws_iam_openid_connect_provider_extract_from_arn = element(split("oidc-provider/", "${var.oidc_connector_arn}"), 1)
}

# Create AWSLoadBalancerControllerIAMPolicy for aws-load-balancer-controller
resource "aws_iam_policy" "AWSLoadBalancerControllerIAMPolicy" {
  name        = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "AWS load balancer controller IAM policy"
  policy      = data.http.AWSLoadBalancerControllerIAMPolicy.response_body
}

resource "aws_iam_policy" "AWSLoadBalancerControllerAdditionalIAMPolicy" {
  name        = "${var.cluster_name}-AWSLoadBalancerControllerAdditionalIAMPolicy"
  path        = "/"
  description = "AWS load balancer controller IAM policy"
  policy      = data.http.AWSLoadBalancerControllerAdditionalIAMPolicy.response_body
}


# Create an IAM Role 
resource "aws_iam_role" "AmazonEKSLoadBalancerControllerRole" {
  name = "${var.cluster_name}-AmazonEKSLoadBalancerControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${data.aws_iam_openid_connect_provider.oidc-connector.arn}"
        }
        Condition = {
          StringEquals = {
            "${element(split("oidc-provider/", "${var.oidc_connector_arn}"), 1)}:aud" : "sts.amazonaws.com",
            "${element(split("oidc-provider/", "${var.oidc_connector_arn}"), 1)}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      },
    ]
  })

  tags = {
    tag-key = "${var.cluster_name}-AmazonEKSLoadBalancerControllerRole"
  }

  depends_on = [aws_iam_policy.AWSLoadBalancerControllerAdditionalIAMPolicy,
  aws_iam_policy.AWSLoadBalancerControllerIAMPolicy]
}

resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerIAMPolicy-attachment" {
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerIAMPolicy.arn
  role       = aws_iam_role.AmazonEKSLoadBalancerControllerRole.name
}

resource "aws_iam_role_policy_attachment" "AWSLoadBalancerControllerAdditionalIAMPolicy-attachment" {
  policy_arn = aws_iam_policy.AWSLoadBalancerControllerAdditionalIAMPolicy.arn
  role       = aws_iam_role.AmazonEKSLoadBalancerControllerRole.name
}


# Create Service account of aws-load-balancer-controller
resource "kubernetes_service_account" "aws-load-balancer-controller" {
  depends_on = [aws_iam_role_policy_attachment.AWSLoadBalancerControllerIAMPolicy-attachment,
  aws_iam_role_policy_attachment.AWSLoadBalancerControllerAdditionalIAMPolicy-attachment]
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.AmazonEKSLoadBalancerControllerRole.arn
    }

    labels = {
      "app.kubernetes.io/name" = "aws-load-balancer-controller"
      #   "app.kuberenets.io/managed-by" = "terraform"
      "app.kubernetes.io/component" = "controller"
    }
  }
}

# Install the AWS Load Balancer Controller. 
resource "helm_release" "helm-alb-controller" {
  depends_on = [kubernetes_service_account.aws-load-balancer-controller]
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.aws-load-balancer-controller.metadata[0].name
  }

  set {
    name = "vpcId"
    value = var.vpc_id
  }
}

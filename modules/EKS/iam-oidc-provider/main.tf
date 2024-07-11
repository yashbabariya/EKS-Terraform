
data "tls_certificate" "eks" {
  url = var.oidc_url
}

resource "aws_iam_openid_connect_provider" "oidc-connector" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = var.oidc_url
}

data "aws_iam_policy_document" "oidc-role-policy-document" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.oidc-connector.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-test"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.oidc-connector.arn]
      type        = "Federated"
    }
  }
  depends_on = [aws_iam_openid_connect_provider.oidc-connector]
}

resource "aws_iam_role" "oidc-role" {
  assume_role_policy = data.aws_iam_policy_document.oidc-role-policy-document.json
  name               = "${var.cluster_name}-oidc-role"
}

resource "aws_iam_policy" "oidc-policy" {
  depends_on = [aws_iam_role.oidc-role]
  name       = "${var.cluster_name}-oidc-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:ListAllMyBuckets",
        "s3:GetBucketLocation",
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "oidc-role-attachment" {
  role       = aws_iam_role.oidc-role.name
  policy_arn = aws_iam_policy.oidc-policy.arn
}


output "oidc_connector_arn" {
    description = "AWS IAM OpenID Provider OIDC connector ARN value"
    value = aws_iam_openid_connect_provider.oidc-connector.arn
}
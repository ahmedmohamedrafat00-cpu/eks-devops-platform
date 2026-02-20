resource "aws_iam_role" "jenkins_irsa" {
  count = var.enable_irsa ? 1 : 0

  name = "jenkins-irsa-role-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = local.oidc_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:aud" = "sts.amazonaws.com"
            "${local.oidc_provider}:sub" = "system:serviceaccount:ci:jenkins"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "jenkins_ecr_policy" {
  count = var.enable_irsa ? 1 : 0

  name = "jenkins-ecr-policy-${var.cluster_name}"
  role = aws_iam_role.jenkins_irsa[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "*"
      }
    ]
  })
}

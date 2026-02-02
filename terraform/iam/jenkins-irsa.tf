locals {
  oidc_provider = replace(
    data.aws_eks_cluster.eks.identity[0].oidc[0].issuer,
    "https://",
    ""
  )
}
# ---------------------------------
# Jenkins IRSA Role
# ---------------------------------
resource "aws_iam_role" "jenkins_irsa" {
  name = "jenkins-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${local.oidc_provider}:sub" = "system:serviceaccount:ci:jenkins"
          }
        }
      }
    ]
  })
}
# ---------------------------------
# Jenkins – EKS permissions
# ---------------------------------
resource "aws_iam_role_policy_attachment" "jenkins_irsa_policy" {
  role       = aws_iam_role.jenkins_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ---------------------------------
# Jenkins – ECR permissions
# ---------------------------------
resource "aws_iam_role_policy" "jenkins_ecr_policy" {
  name = "jenkins-ecr-policy"
  role = aws_iam_role.jenkins_irsa.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
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

# ---------------------------------
# Jenkins IRSA Role (EKS)
# ---------------------------------

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.eks_cluster_name
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd2e9f1"]
}

resource "aws_iam_role" "jenkins_irsa" {
  name = "jenkins-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            format(
              "%s:sub",
              replace(
                data.aws_eks_cluster.eks.identity[0].oidc[0].issuer,
                "https://",
                ""
              )
            ) = "system:serviceaccount:cicd:jenkins"
          }
        }
      }
    ]
  })
} 

resource "aws_iam_role_policy_attachment" "jenkins_irsa_policy" {
  role       = aws_iam_role.jenkins_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_eks_cluster" "eks" {
  count = var.enable_irsa ? 1 : 0
  name  = var.cluster_name
}

data "aws_iam_openid_connect_provider" "eks" {
  count = var.enable_irsa ? 1 : 0
  url   = data.aws_eks_cluster.eks[0].identity[0].oidc[0].issuer
}

locals {
  oidc_provider = var.enable_irsa ? replace(data.aws_eks_cluster.eks[0].identity[0].oidc[0].issuer, "https://", "") : ""
  oidc_arn      = var.enable_irsa ? data.aws_iam_openid_connect_provider.eks[0].arn : ""
}

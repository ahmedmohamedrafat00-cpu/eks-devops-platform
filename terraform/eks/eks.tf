resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.34"

  vpc_config {
    subnet_ids = data.terraform_remote_state.network.outputs.private_subnets

    endpoint_private_access = true
    endpoint_public_access  = true
  }
}

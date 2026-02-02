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

resource "aws_security_group_rule" "eks_allow_bastion_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"

  security_group_id        = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  source_security_group_id = data.terraform_remote_state.servers_setup.outputs.bastion_sg_id
}

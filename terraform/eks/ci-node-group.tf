resource "aws_eks_node_group" "ci" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "ci-node-group"

  node_role_arn = aws_iam_role.eks_node_role.arn

  subnet_ids = data.terraform_remote_state.network.outputs.private_subnets

  instance_types = ["t3.large"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 4
  }

  labels = {
    role = "ci"
  }

  taint {
    key    = "ci"
    value  = "true"
    effect = "NO_SCHEDULE"
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_readonly
  ]
}

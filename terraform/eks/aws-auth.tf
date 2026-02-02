resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn = aws_iam_role.eks_node_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
          "system:bootstrappers",
          "system:nodes"
        ]
      },
      {
        rolearn = data.terraform_remote_state.iam.outputs.ansible_role_arn
        username = "ansible"
        groups = ["system:masters"]
      },
      {
        rolearn = data.terraform_remote_state.iam.outputs.bastion_role_arn
        username = "bastion"
        groups = ["system:masters"]
      }
    ])
  }
}

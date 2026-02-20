resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = data.terraform_remote_state.eks.outputs.nodegroup_role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      },
      {
        rolearn  = data.terraform_remote_state.iam.outputs.ansible_role_arn
        username = "ansible"
        groups   = ["system:masters"]
      },
      {
        rolearn  = data.terraform_remote_state.iam.outputs.bastion_role_arn
        username = "bastion"
        groups   = ["system:masters"]
      }
      # ,{
      #   rolearn  = data.terraform_remote_state.iam.outputs.jenkins_irsa_role_arn
      #   username = "system:serviceaccount:ci:jenkins"
      #   groups   = ["system:masters"]
      # }
    ])

    mapUsers = yamlencode([])
  }
}

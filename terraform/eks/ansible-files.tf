variable "aws_region" {
  type = string
}

variable "account_id" {
  type = string
}

locals {
  ansible_vars_path = "${path.module}/../../ansible/group_vars/generated.eks.yml"
}

resource "local_file" "ansible_generated_vars" {
  filename = local.ansible_vars_path

  content = yamlencode({
    aws_region       = var.aws_region
    eks_cluster_name = aws_eks_cluster.this.name

    ecr = {
      account_id = var.account_id
      region     = var.aws_region
      registry   = "${var.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    }
  })
}

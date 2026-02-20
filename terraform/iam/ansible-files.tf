locals {
  ansible_vars_path = "${path.module}/../../ansible/group_vars/generated.iam.yml"
}

resource "local_file" "ansible_generated_vars" {
  filename = local.ansible_vars_path

  content = yamlencode({
    alb_controller_role_arn   = try(aws_iam_role.alb_controller[0].arn, null)
    external_secrets_role_arn = try(aws_iam_role.external_secrets_irsa[0].arn, null)
    jenkins_irsa_role_arn     = try(aws_iam_role.jenkins_irsa[0].arn, null)
  })
}

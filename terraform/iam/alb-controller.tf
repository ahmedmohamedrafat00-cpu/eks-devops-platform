resource "aws_iam_policy" "alb_controller_policy" {
  count  = var.enable_irsa ? 1 : 0
  name   = "AWSLoadBalancerControllerIAMPolicy-${var.cluster_name}"
  policy = file("${path.module}/alb-controller-policy.json")
}

data "aws_iam_policy_document" "alb_controller_assume_role" {
  count = var.enable_irsa ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [local.oidc_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  count              = var.enable_irsa ? 1 : 0
  name               = "alb-controller-role-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "alb_controller_policy_attach" {
  count      = var.enable_irsa ? 1 : 0
  role       = aws_iam_role.alb_controller[0].name
  policy_arn = aws_iam_policy.alb_controller_policy[0].arn
}

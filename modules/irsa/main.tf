locals {
  oidc_url_hostpath = replace(var.oidc_provider_url, "https://", "")
  sa_namespace      = "kube-system"
  sa_name           = "aws-load-balancer-controller"
}

# 1) Create the official AWS Load Balancer Controller policy from file
#    Save the JSON file (see note below) at: policies/aws-load-balancer-controller.json
resource "aws_iam_policy" "this" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Permissions for AWS Load Balancer Controller on EKS ${var.cluster_name}"
  policy      = file("${path.module}/policies/aws-load-balancer-controller.json")
  tags        = var.tags
}

# 2) Trust policy for IRSA
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url_hostpath}:sub"
      values   = ["system:serviceaccount:${local.sa_namespace}:${local.sa_name}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url_hostpath}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# 3) Role for the controller
resource "aws_iam_role" "this" {
  name               = "${var.cluster_name}-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.trust.json
  tags               = var.tags
}

# 4) Attach policy to role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

output "role_arn" {
  value = aws_iam_role.this.arn
}

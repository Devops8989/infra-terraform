# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.8.4" # latest stable

#   cluster_name    = var.cluster_name
#   cluster_version = var.cluster_version
#   vpc_id          = var.vpc_id
#   subnet_ids      = concat(var.private_subnets, var.public_subnets)

#   tags = var.tags

#   # Enable IAM OIDC Provider for IRSA
#   enable_irsa = true

#   eks_managed_node_groups = {
#     default = {
#       instance_types = ["t3.medium"]
#       desired_size   = 2
#       min_size       = 1
#       max_size       = 3
#     }
#   }
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  tags = var.tags

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      subnets        = var.private_subnets
    }
  }
}


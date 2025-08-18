module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  tags            = var.tags
}

# module "eks" {
#   source          = "./modules/eks"
#   cluster_name    = var.cluster_name
#   cluster_version = var.cluster_version
#   vpc_id          = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnets
#   public_subnets  = module.vpc.public_subnets
#   tags            = var.tags
# }

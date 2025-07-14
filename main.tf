module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b"]
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets      = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  ### ✅ Enable public API access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true # You can also set this to false if you only want public

  eks_managed_node_groups = {
    dev-nodes = {
      instance_types = [var.node_instance_type]
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_capacity
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}



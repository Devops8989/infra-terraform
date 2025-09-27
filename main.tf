# module "vpc" {
#   source          = "./modules/vpc"
#   vpc_cidr        = var.vpc_cidr
#   public_subnets  = var.public_subnets
#   private_subnets = var.private_subnets
#   azs             = var.azs
#   tags            = var.tags
# }

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
  environment     = var.environment

  tags = {
    Environment = var.environment
    Project     = "eks"
  }
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  subnet_ids      = module.vpc.private_subnets
  tags            = var.tags
}

# module "security_group" {
#   source       = "./modules/security-group"
#   vpc_id       = module.vpc.vpc_id
#   cluster_name = var.cluster_name
#   tags         = var.tags
# }

# module "backend_irsa" {
#   source               = "./modules/irsa"
#   cluster_name         = var.cluster_name
#   oidc_provider_arn    = module.eks.oidc_provider_arn
#   oidc_provider_url    = module.eks.oidc_provider_url
#   k8s_namespace        = "staging"
#   service_account_name = "backend-sa"
#   secrets_arn          = "arn:aws:secretsmanager:ap-south-1:111111111111:secret:mongodb-atlas-connection"
#   tags                 = var.tags
# }

# module "mongodb_secret" {
#   source      = "./modules/secrets-manager"
#   secret_name = "mongodb-atlas-connection"
#   description = "MongoDB Atlas connection string for backend"
#   secret_value = jsonencode({
#     uri      = "mongodb+srv://username:password@cluster0.mongodb.net/mydb?retryWrites=true&w=majority"
#     username = "username"
#     password = "password"
#   })
#   tags = var.tags
# }

# module "dockerhub_secret" {
#   source      = "./modules/secrets-manager"
#   secret_name = "dockerhub-credentials"
#   description = "DockerHub credentials for pulling images"
#   secret_value = jsonencode({
#     username = "your-dockerhub-username"
#     password = "your-dockerhub-password-or-access-token"
#   })
#   tags = var.tags
# }

# module "alb_irsa" {
#   source             = "./modules/irsa"
#   cluster_name       = var.cluster_name
#   oidc_provider_arn  = module.eks.oidc_provider_arn
#   oidc_provider_url  = module.eks.oidc_provider_url
#   tags               = var.tags
# }


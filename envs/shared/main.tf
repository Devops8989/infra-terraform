terraform {
  required_version = ">= 1.5.0"

  #   backend "s3" {
  #     bucket         = "my-terraform-prod-state"
  #     key            = "staging/terraform.tfstate"
  #     region         = "us-east-1"
  #     dynamodb_table = "terraform-lock"
  #     encrypt        = true
  #   }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# provider "aws" {
#   region = var.aws_region
#   profile = "shared-account"
# }

provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::583534901542:role/terraform-backend-access-role"
    session_name = "jenkins-terraform"
  }
}


module "vpc" {
  source = "../../modules/vpc"

  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

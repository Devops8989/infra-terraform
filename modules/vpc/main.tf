# resource "aws_vpc" "this" {
#   cidr_block           = var.vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags                 = merge(var.tags, { Name = "${var.tags["Project"]}-vpc" })
# }

# resource "aws_subnet" "public" {
#   count                   = length(var.public_subnets)
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = var.public_subnets[count.index]
#   availability_zone       = var.azs[count.index]
#   map_public_ip_on_launch = true
#   tags                    = merge(var.tags, { Name = "public-${count.index + 1}" })
# }

# resource "aws_subnet" "private" {
#   count             = length(var.private_subnets)
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = var.private_subnets[count.index]
#   availability_zone = var.azs[count.index]
#   tags              = merge(var.tags, { Name = "private-${count.index + 1}" })
# }


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.environment
  }
}



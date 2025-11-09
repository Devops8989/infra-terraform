terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# -------- Provider Configuration --------
provider "aws" {
  region  = var.region
  profile = var.profile
}

# -------- Get AWS Account Info --------
data "aws_caller_identity" "current" {}

# -------- KMS Key for Terraform State Encryption --------
# resource "aws_kms_key" "tfstate" {
#   description             = "KMS key for Terraform remote state encryption"
#   deletion_window_in_days = 30
#   enable_key_rotation     = true

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid      = "AllowRootAccountFullAccess"
#         Effect   = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       }
#     ]
#   })
# }

# -------- S3 Bucket for Remote State --------
resource "aws_s3_bucket" "tfstate" {
  bucket        = var.tf_bucket_name
  force_destroy = false

  tags = {
    Name        = "terraform-backend"
    Environment = "shared-services"
  }
}

# Enable Versioning
# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.tfstate.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# Encrypt Bucket with KMS
# resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
#   bucket = aws_s3_bucket.tfstate.bucket

#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "aws:kms"
#       kms_master_key_id = aws_kms_key.tfstate.arn
#     }
#   }
# }

# Block All Public Access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Lifecycle Rule - clean old versions
# resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
#   bucket = aws_s3_bucket.tfstate.id

#   rule {
#     id     = "expire_old_versions"
#     status = "Enabled"

#     noncurrent_version_expiration {
#       noncurrent_days = 30
#     }
#   }
# }

# -------- DynamoDB Table for Terraform Lock --------
resource "aws_dynamodb_table" "locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-locks"
    Environment = "shared-services"
  }
}

# -------- Outputs --------
output "s3_bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}

# output "kms_key_arn" {
#   value = aws_kms_key.tfstate.arn
# }

output "dynamodb_table_name" {
  value = aws_dynamodb_table.locks.name
}

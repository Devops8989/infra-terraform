terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "shared-account"
}

variable "region" { default = "us-east-1" }
variable "tf_bucket_name" { default = "myorg-tf-state" }
variable "dynamodb_table_name" { default = "terraform-locks" }

resource "aws_kms_key" "tfstate" {
  description             = "KMS key for Terraform remote state"
  deletion_window_in_days = 30
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "${data.aws_caller_identity.current.account_id}" },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "tfstate" {
  bucket = var.tf_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.tfstate.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = 30
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

//output "bucket_name" { value = aws_s3_bucket.tfstate.id }
//output "dynamodb_table" { value = aws_dynamodb_table.locks.name }
//output "kms_key_arn" { value = aws_kms_key.tfstate.arn }

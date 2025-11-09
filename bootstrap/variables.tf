variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS CLI profile name"
  default     = "shared-account"
}

variable "tf_bucket_name" {
  description = "Name of S3 bucket for Terraform backend"
  default     = "doctorlink-tf-state"
}

variable "dynamodb_table_name" {
  description = "Name of DynamoDB table for state locking"
  default     = "terraform-locks"
}

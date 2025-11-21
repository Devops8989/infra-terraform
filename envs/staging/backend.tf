# terraform {
#   backend "s3" {
#     bucket         = "doctorlink-tf-state"
#     key            = "staging/eks/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#   }
# }
terraform {
  backend "s3" {
    bucket         = "doctorlink-tf-state"
    key            = "shared/doctorlink-tf-state"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true

    assume_role = {
      role_arn     = "arn:aws:iam::642384808985:role/TerraformDeployRole-staging"
      session_name = "tf-backend"
    }
  }
}
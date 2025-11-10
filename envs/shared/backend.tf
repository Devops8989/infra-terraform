terraform {
  backend "s3" {
    bucket         = "doctorlink-tf-state"
    key            = "shared/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "shared-account"
  }
}

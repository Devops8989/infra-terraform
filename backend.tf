terraform {
  backend "s3" {
    bucket         = "sajal-s3-demo-1.1.1.2" # change this
    key            = "sajal/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

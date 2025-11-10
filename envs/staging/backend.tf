terraform {
  backend "s3" {
    bucket         = "doctorlink-tf-state"
    key            = "staging/eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}

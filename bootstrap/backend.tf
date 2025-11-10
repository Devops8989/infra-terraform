terraform {
  backend "s3" {
    bucket = "doctorlink-tf-state"
    key    = "doctorlink-tf-state"
    region = "us-east-1"
  }
}

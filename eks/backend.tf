terraform {
  backend "s3" {
    bucket = "cicd-tjen"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
  backend "s3" {
    bucket = "cicd-tjen"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bootcamp-impacta"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
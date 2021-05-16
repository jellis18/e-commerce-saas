terraform {
  backend "s3" {
    bucket = "proshop-terraform"
    key    = "state/terraform.tfstate"
    region = "us-east-2"
  }
}

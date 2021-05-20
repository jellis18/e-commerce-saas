terraform {
  backend "s3" {
    bucket = "proshop-terraform"
    key    = "state/terraform.tfstate"
    region = "us-east-2"
  }
}

# Configure the GitHub Provider
# Use token through environment variable
provider "github" {

}

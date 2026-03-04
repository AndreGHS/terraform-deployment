terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-2026"
    key = "terraform.tfstate"
    region = "$AWS_REGION"
    encrypt = true
  }
}
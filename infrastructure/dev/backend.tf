terraform {
  backend "s3" {
    bucket         = "team7-dev-tf-state"  # Static name (matches bootstrap)
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "team7-dev-tf-lock"   # Static name (matches bootstrap)
  }
}
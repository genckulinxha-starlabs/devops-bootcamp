terraform {
  backend "s3" {
    bucket         = "shefqet-terraform-state-20251026"  # matches the fixed bucket created in s3.tf
    key            = "global/s3/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "shefqet-terraform-state-locks-20251026"       # DynamoDB locking table name
    use_lockfile   = true
    encrypt        = true
  }
}

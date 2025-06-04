# backend.tf
terraform {
  backend "s3" {
    bucket         = ""
    key            = ""
    region         = ""
    profile        = ""
    dynamodb_table = "multi-env-terraform-state-lock"
    encrypt        = true
  }


}
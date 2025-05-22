

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Optional: Specify the required Terraform version
  required_version = ">= 1.0.0"

  # Optionally configure remote state
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "multi-env-vpc/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
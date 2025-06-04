# # backend.tf
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "cicd-pipeline/terraform.tfstate"
#     region         = "us-west-2"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
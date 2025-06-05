# 

# =============================================================

# # outputs.tf
output "terraform_state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = aws_s3_bucket.remote_state_bucket.bucket

}

output "terraform_state_lock_table_name" {
  description = "DynamoDB table name for Terraform state lock"
  value       = aws_dynamodb_table.remote_state_lock_table.name
}



output "prod_vpc_id" {
  description = "Production VPC ID"
  value       = module.prod_vpc.vpc_id
}

output "dev_vpc_id" {
  description = "Development VPC ID"
  value       = module.dev_vpc.vpc_id
}

output "staging_vpc_id" {
  description = "Staging VPC ID"
  value       = module.staging_vpc.vpc_id
  
}
output "mgnt_vpc_id" {
  description = "Management VPC ID"
  value       = module.mgnt_vpc.vpc_id
}

output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = module.transit_gateway.transit_gateway_id
}

output "security_group_ids" {
  description = "Security Group IDs"
  value       = module.security.security_group_ids
}

output "prod_private_subnet_ids" {
  description = "Production private subnet IDs"
  value       = module.prod_vpc.private_subnet_ids
}

output "dev_private_subnet_ids" {
  description = "Development private subnet IDs"
  value       = module.dev_vpc.private_subnet_ids
}
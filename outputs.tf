# 

# =============================================================

# outputs.tf
output "prod_vpc_id" {
  description = "Production VPC ID"
  value       = module.prod_vpc.vpc_id
}

output "dev_vpc_id" {
  description = "Development VPC ID"
  value       = module.dev_vpc.vpc_id
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
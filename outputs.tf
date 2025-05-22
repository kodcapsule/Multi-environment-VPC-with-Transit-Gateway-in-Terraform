output "production_vpc_id" {
  description = "ID of the Production VPC"
  value       = aws_vpc.prod.id
}

output "development_vpc_id" {
  description = "ID of the Development VPC"
  value       = aws_vpc.dev.id
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.id
}

output "prod_private_subnet_ids" {
  description = "IDs of the Production private subnets"
  value       = aws_subnet.prod_private[*].id
}

output "dev_private_subnet_ids" {
  description = "IDs of the Development private subnets"
  value       = aws_subnet.dev_private[*].id
}

output "prod_app_security_group_id" {
  description = "ID of the Production application security group"
  value       = aws_security_group.prod_app.id
}

output "dev_app_security_group_id" {
  description = "ID of the Development application security group"
  value       = aws_security_group.dev_app.id
}
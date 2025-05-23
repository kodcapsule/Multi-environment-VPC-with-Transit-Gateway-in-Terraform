# modules/transit-gateway/outputs.tf
output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_arn" {
  description = "Transit Gateway ARN"
  value       = aws_ec2_transit_gateway.main.arn
}

output "vpc_attachment_ids" {
  description = "Map of VPC attachment IDs"
  value       = { for k, v in aws_ec2_transit_gateway_vpc_attachment.attachments : k => v.id }
}
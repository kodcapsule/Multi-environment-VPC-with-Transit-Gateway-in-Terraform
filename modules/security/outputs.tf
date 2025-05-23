# modules/security/outputs.tf
output "security_group_ids" {
  description = "Map of security group IDs"
  value       = { for k, v in aws_security_group.main : k => v.id }
}

output "network_acl_ids" {
  description = "Map of network ACL IDs"
  value       = { for k, v in aws_network_acl.main : k => v.id }
}
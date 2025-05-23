
# modules/security/variables.tf
variable "security_groups" {
  description = "Map of security groups to create"
  type = map(object({
    name        = string
    description = string
    vpc_id      = string
    ingress_rules = map(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
    egress_rules = map(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
    tags = map(string)
  }))
  default = {}
  
}




variable "network_acls" {
  description = "Map of network ACLs to create"
  type = map(object({
    name       = string
    vpc_id     = string
    subnet_ids = list(string)
    ingress_rules = map(object({
      rule_number = number
      protocol    = string
      action      = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
    egress_rules = map(object({
      rule_number = number
      protocol    = string
      action      = string
      cidr_block  = string
      from_port   = number
      to_port     = number
    }))
    tags = map(string)
  }))
  default = {}
}





variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}


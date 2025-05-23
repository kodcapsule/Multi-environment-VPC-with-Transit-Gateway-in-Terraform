
variable "name" {
  description = "Name of the Transit Gateway"
  type        = string
  validation {
    condition     = length(var.name) > 2
    error_message = "Name cannot be empty or less than 2 characters."
  }
}



variable "description" {
  description = "Description of the Transit Gateway"
  type        = string
  default     = "Transit Gateway for multi-environment architecture"
}



variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = string
  default     = "enable"
  
}



variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = string
  default     = "enable"

    validation {
        condition     = can(regex("^(enable|disable)$", var.default_route_table_propagation))
        error_message = "default_route_table_propagation must be either 'enable' or 'disable'."
    }
}



variable "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = string
  default     = "disable"

    validation {
        condition     = can(regex("^(enable|disable)$", var.auto_accept_shared_attachments))
        error_message = "auto_accept_shared_attachments must be either 'enable' or 'disable'."
    }

}



variable "vpc_attachments" {
  description = "Map of VPC attachments to create"
  type = map(object({
    vpc_id      = string
    subnet_ids  = list(string)
    environment = string
  }))
  default = {}
    validation {
        condition     = length(var.vpc_attachments) > 0
        error_message = "At least one VPC attachment must be specified."
    }
}




variable "vpc_routes" {
  description = "Map of routes to add to VPC route tables"
  type = map(object({
    route_table_id         = string
    destination_cidr_block = string
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}


variable "amazon_side_asn" {
  description = "The ASN for the Amazon side of a BGP session"
  type        = string
  default     = "64512"

  validation {
    condition     = can(regex("^(65[0-3][0-5][0-1]|64[0-9]{2}|6[0-3][0-9]{3}|[1-5][0-9]{4}|[1-9][0-9]{0,4})$", var.amazon_side_asn))
    error_message = "amazon_side_asn must be a valid ASN."
  }
  
}
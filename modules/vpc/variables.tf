
variable "vpc_cidr" {
  description = "CIDR block for  VPC (must be a private IP, /16 or more specific)"
  type        = string
  default = "10.0.0.0/16"

  # validation {
  #       condition = can(regex("^10\\.0\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)/16$", var.prod_vpc_cidr))
  #       error_message = "CIDR must be in 10.0.0.0/16 with valid octets (0–255), like 10.0.1.100/16"
  #     }

  validation {
    condition = can(regex("^((10\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d))|(172\\.(1[6-9]|2[0-9]|3[0-1])\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d))|(192\\.168\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)))\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)/(1[6-9]|2[0-9]|3[0-2])$", var.dev_vpc_cidr))
    error_message = "CIDR must be a valid private IP range (10.0.0.0/16, 172.16.0.0/16, or 192.168.0.0/16) with a subnet mask of /16 or more specific"
  }

  
}

 


variable "environment" {
  description = "Environment name"
  type        = string
    validation {
    condition     = length(var.environment) > 2
    error_message = "Environment name cannot be empty or less than 2 characters."
  }
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 1
    error_message = "At least one availability zone must be specified."
  }
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]+$", var.tags))
    error_message = "Tags can only contain alphanumeric characters and underscores."
  }
}

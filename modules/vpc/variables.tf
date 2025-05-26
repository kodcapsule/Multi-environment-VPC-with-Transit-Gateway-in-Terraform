
variable "vpc_cidr" {
  description = "CIDR block for  VPC (must be a private IP, /16 or more specific)"
  type        = string
  default = "10.0.0.0/16"


  # check if the provided CIDR block is a valid format

#   validation {
#   condition = can(regex("^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$", var.vpc_cidr))
#   error_message = "Must be a valid IPv4 address format (e.g., 192.168.1.1). Each octet must be between 0-255."
# }
  

  validation {
    condition = can(regex("^((10\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d))|(172\\.(1[6-9]|2[0-9]|3[0-1])\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d))|(192\\.168\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)))\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)/(1[6-9]|2[0-9]|3[0-2])$", var.vpc_cidr))
    error_message = "CIDR must be a valid private IP range (10.0.0.0/16, 172.16.0.0/16, or 192.168.0.0/16) with a subnet mask of /16 or more specific"
  }

  # check if ip block provided is Ipv6 and throw error to user that ipv6 is not supported
  validation {
    condition = can(regex("^(?!.*::)([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.vpc_cidr)) == false
    error_message = "IPv6 CIDR blocks are not supported. Please provide a valid IPv4 CIDR block."
  }

  
}

 


variable "environment" {
  description = "Environment name"
  type        = string
    validation {
    condition     = length(var.environment) > 2
    error_message = "Environment name cannot be empty or less than 2 characters."
  }

  # validation for environment name to allow only alphanumeric characters, underscores, and hyphens
  validation {
    condition = can(regex("^[a-zA-Z0-9_-]+$", var.environment))
    error_message = "Environment name can only contain alphanumeric characters, underscores, and hyphens."
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

  # Validation for tags  
  validation {
    condition = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9_-]+$", k)) && can(regex("^[a-zA-Z0-9_\\s-]+$", v)) ])
    error_message = "Tags can only contain alphanumeric characters, underscores, and hyphens."
  }

  validation {
    condition     = length(var.tags) <= 10
    error_message = "A maximum of 10 tags can be specified."
  }
}

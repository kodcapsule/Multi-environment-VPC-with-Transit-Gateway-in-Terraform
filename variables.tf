# 

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

validation {
    condition     = can(regex("^(us|eu|ap|sa|ca)-[a-z]+-[1-9][0-9]$", var.aws_region))
    error_message = "Invalid AWS region format. Use 'us-east-1', 'eu-west-1', etc."
  }
  

  validation {
    condition     = length(var.aws_region) > 0
    error_message = "AWS region cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must consist of lowercase letters, numbers, and hyphens only."
  }
}



variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "wewoli"

validation {
    condition     = length(var.aws_profile) > 0
    error_message = "AWS profile cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]+$", var.aws_profile))
    error_message = "AWS profile must consist of alphanumeric characters and underscores only."
  }

}



variable "prod_vpc_cidr" {
  description = "CIDR block for production VPC"
  type        = string
  default     = "10.0.0.0/18"


}

variable "dev_vpc_cidr" {
  description = "CIDR block for development VPC"
  type        = string
  default     = "10.0.64.0/18"
}

variable "staging_vpc_cidr" {
  description = "CIDR block for staging VPC"
  type        = string
  default     = "10.0.128.0/18"

}

variable "mgnt_vpc_cidr" {
  description = "CIDR block for management VPC"
  type        = string
  default     = "10.0.192.0/18"

}





variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  validation {
    condition     = length(var.availability_zones) > 0
    error_message = "At least one availability zone must be specified."
  }
}

variable "environment" {
  description = "Environment/Project name"
  type        = string
  default     = "multi-env"

  validation {
    condition     = length(var.environment) > 0
    error_message = "Environment name cannot be empty."
  }
}
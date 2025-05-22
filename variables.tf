variable "aws_region" {
  description = "AWS region to deploy your  resources"
  type        = string
  validation {
    condition     = contains(["us-east-1"], var.aws_region)
    error_message = "The AWS region must be one of the following: us-east-1, us-west-2, eu-west-1."
  }
  default = "us-east-1"

}



variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = "default"
  validation {
    condition     = length(var.aws_profile) > 0
    error_message = "AWS profile cannot be empty."
  }
}

variable "prod_vpc_cidr" {
  description = "CIDR block for production VPC"
  default = "10.0.0.0/16"
    validation {
        condition = can(regex("^10\\.0\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)/16$", var.prod_vpc_cidr))
        error_message = "CIDR must be in 10.0.0.0/16 with valid octets (0–255), like 10.0.1.100/16"
      }
}



variable "dev_vpc_cidr" {
  description = "CIDR block for development VPC"
  default     = "10.1.0.0/16"
      validation {
        condition = can(regex("^10\\.1\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)\\.(25[0-5]|2[0-4]\\d|1\\d{2}|[1-9]?\\d)/16$", var.dev_vpc_cidr))
        error_message = "CIDR must be in 10.1.0.0/16 with valid octets (0–255), like 10.1.1.100/16"
      }
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)

  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  validation {
    condition     = length(var.availability_zones) >= 1
    error_message = "At least one availability zone must be specified."
  }
}


variable "environment" {
  description = "Environment for resource tagging"
  default     = "dev"
  type        = string
  # define tags for environment

  validation {
    condition     = length(var.environment) > 2
    error_message = "Environment name cannot be  empty or less than 2 characters."
  }

  validation {
    condition     = contains(["dev", "prod", "staging"], var.environment)
    error_message = "Environment must be either 'dev' , 'prod'or 'staging'."
  }


}
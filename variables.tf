# 

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "wewoli"

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
}
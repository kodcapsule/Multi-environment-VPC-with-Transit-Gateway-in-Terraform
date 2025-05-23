# 

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"

}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"

}



variable "prod_vpc_cidr" {
  description = "CIDR block for production VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dev_vpc_cidr" {
  description = "CIDR block for development VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "environment" {
  description = "Environment/Project name"
  type        = string
  default     = "multi-env"
}
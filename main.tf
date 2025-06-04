


# This Terraform configuration sets up a multi-environment architecture on AWS with VPCs, Transit Gateway, and security configurations.
resource "aws_s3_bucket" "remote_state_bucket" {
  bucket = "${var.environment}-hub-spoke-terraform-state"

  tags = {
    Name        = "${var.environment}-terraform-state"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }


}

resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.remote_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "dfault_encryption" {
  bucket = aws_s3_bucket.remote_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_public_access_block" "name" {
  bucket                  = aws_s3_bucket.remote_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}


resource "aws_dynamodb_table" "remote_state_lock_table" {
  name         = "${var.environment}-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.environment}-terraform-state-lock"
    Environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }

}

# ========================================================================

# Create Production VPC
# module "prod_vpc" {
#   source = "./modules/vpc"

#   vpc_cidr           = var.prod_vpc_cidr
#   environment        = "production"
#   availability_zones = var.availability_zones

#   tags = {
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# # Create Development VPC
# module "dev_vpc" {
#   source = "./modules/vpc"

#   vpc_cidr           = var.dev_vpc_cidr
#   environment        = "development"
#   availability_zones = var.availability_zones

#   tags = {
#     Environment = "development"
#     Project     = var.environment
#   }
# }


# module "staging_vpc" {
#   source = "./modules/vpc"

#   vpc_cidr           = var.staging_vpc_cidr
#   environment        = "staging"
#   availability_zones = var.availability_zones

#   tags = {
#     Environment = "staging"
#     Project     = var.environment
#   }

# }

# module "management_vpc" {
#   source = "./modules/vpc"

#   vpc_cidr           = var.mgnt_vpc_cidr
#   environment        = "management"
#   availability_zones = var.availability_zones

#   tags = {
#     Environment = "management"
#     Project     = var.environment
#   }

# }

# # Create Transit Gateway with attachments
# module "transit_gateway" {
#   source = "./modules/transit-gateway"

#   name        = "multi-env-tgw"
#   description = "Transit Gateway for multi-environment architecture"

#   vpc_attachments = {
#     prod = {
#       vpc_id      = module.prod_vpc.vpc_id
#       subnet_ids  = module.prod_vpc.private_subnet_ids
#       environment = "production"
#     }
#     dev = {
#       vpc_id      = module.dev_vpc.vpc_id
#       subnet_ids  = module.dev_vpc.private_subnet_ids
#       environment = "dev"
#     }
#   }

#   vpc_routes = {
#     # Production routes to Dev
#     prod_to_dev_public = {
#       route_table_id         = module.prod_vpc.public_route_table_id
#       destination_cidr_block = var.dev_vpc_cidr
#     }
#     prod_to_dev_private = {
#       route_table_id         = module.prod_vpc.private_route_table_id
#       destination_cidr_block = var.dev_vpc_cidr
#     }
#     # Development routes to Prod
#     dev_to_prod_public = {
#       route_table_id         = module.dev_vpc.public_route_table_id
#       destination_cidr_block = var.prod_vpc_cidr
#     }
#     dev_to_prod_private = {
#       route_table_id         = module.dev_vpc.private_route_table_id
#       destination_cidr_block = var.prod_vpc_cidr
#     }
#   }

#   tags = {
#     Project = var.environment
#   }
# }

# # Security configurations
# module "security" {
#   source = "./modules/security"

#   security_groups = {
#     prod_app = {
#       name        = "prod-app-sg"
#       description = "Security group for production application servers"
#       vpc_id      = module.prod_vpc.vpc_id
#       ingress_rules = {
#         https = {
#           from_port   = 443
#           to_port     = 443
#           protocol    = "tcp"
#           cidr_blocks = ["0.0.0.0/0"]
#           description = "Allow HTTPS from anywhere"
#         }
#         ssh = {
#           from_port   = 22
#           to_port     = 22
#           protocol    = "tcp"
#           cidr_blocks = [var.prod_vpc_cidr]
#           description = "Allow SSH from within VPC"
#         }
#       }
#       egress_rules = {
#         all = {
#           from_port   = 0
#           to_port     = 0
#           protocol    = "-1"
#           cidr_blocks = ["0.0.0.0/0"]
#           description = "Allow all outbound traffic"
#         }
#       }
#       tags = {
#         Environment = "production"
#       }
#     }
#     dev_app = {
#       name        = "dev-app-sg"
#       description = "Security group for development application servers"
#       vpc_id      = module.dev_vpc.vpc_id
#       ingress_rules = {
#         http = {
#           from_port   = 80
#           to_port     = 80
#           protocol    = "tcp"
#           cidr_blocks = [var.prod_vpc_cidr]
#           description = "Allow HTTP from Production VPC"
#         }
#         https = {
#           from_port   = 443
#           to_port     = 443
#           protocol    = "tcp"
#           cidr_blocks = [var.prod_vpc_cidr]
#           description = "Allow HTTPS from Production VPC"
#         }
#         ssh = {
#           from_port   = 22
#           to_port     = 22
#           protocol    = "tcp"
#           cidr_blocks = [var.prod_vpc_cidr]
#           description = "Allow SSH from Production VPC"
#         }
#       }
#       egress_rules = {
#         all = {
#           from_port   = 0
#           to_port     = 0
#           protocol    = "-1"
#           cidr_blocks = ["0.0.0.0/0"]
#           description = "Allow all outbound traffic"
#         }
#       }
#       tags = {
#         Environment = "development"
#       }
#     }
#   }

#   network_acls = {
#     prod_private = {
#       name       = "prod-private-nacl"
#       vpc_id     = module.prod_vpc.vpc_id
#       subnet_ids = module.prod_vpc.private_subnet_ids
#       ingress_rules = {
#         internal = {
#           rule_number = 110
#           protocol    = "-1"
#           action      = "allow"
#           cidr_block  = var.prod_vpc_cidr
#           from_port   = 0
#           to_port     = 0
#         }
#         from_dev = {
#           rule_number = 120
#           protocol    = "-1"
#           action      = "allow"
#           cidr_block  = var.dev_vpc_cidr
#           from_port   = 0
#           to_port     = 0
#         }
#         return_traffic = {
#           rule_number = 130
#           protocol    = "tcp"
#           action      = "allow"
#           cidr_block  = "0.0.0.0/0"
#           from_port   = 1024
#           to_port     = 65535
#         }
#       }
#       egress_rules = {
#         all = {
#           rule_number = 140
#           protocol    = "-1"
#           action      = "allow"
#           cidr_block  = "0.0.0.0/0"
#           from_port   = 0
#           to_port     = 0
#         }
#       }
#       tags = {
#         Environment = "production"
#       }
#     }
#     dev_private = {
#       name       = "dev-private-nacl"
#       vpc_id     = module.dev_vpc.vpc_id
#       subnet_ids = module.dev_vpc.private_subnet_ids
#       ingress_rules = {
#         internal = {
#           rule_number = 110
#           protocol    = "-1"
#           action      = "allow"
#           cidr_block  = var.dev_vpc_cidr
#           from_port   = 0
#           to_port     = 0
#         }
#         ssh_from_prod = {
#           rule_number = 120
#           protocol    = "tcp"
#           action      = "allow"
#           cidr_block  = var.prod_vpc_cidr
#           from_port   = 22
#           to_port     = 22
#         }
#         http_from_prod = {
#           rule_number = 130
#           protocol    = "tcp"
#           action      = "allow"
#           cidr_block  = var.prod_vpc_cidr
#           from_port   = 80
#           to_port     = 80
#         }
#         https_from_prod = {
#           rule_number = 140
#           protocol    = "tcp"
#           action      = "allow"
#           cidr_block  = var.prod_vpc_cidr
#           from_port   = 443
#           to_port     = 443
#         }
#         return_traffic = {
#           rule_number = 150
#           protocol    = "tcp"
#           action      = "allow"
#           cidr_block  = "0.0.0.0/0"
#           from_port   = 1024
#           to_port     = 65535
#         }
#       }
#       egress_rules = {
#         all = {
#           rule_number = 100
#           protocol    = "-1"
#           action      = "allow"
#           cidr_block  = "0.0.0.0/0"
#           from_port   = 0
#           to_port     = 0
#         }
#       }
#       tags = {
#         Environment = "development"
#       }
#     }
#   }

#   tags = {
#     Project = var.environment
#   }
# }



# # ============================= DEFINE VPCS ===========================================================
# # Create the Production VPC
# resource "aws_vpc" "prod" {
#   cidr_block           = var.prod_vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name        = "prod-vpc"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# # Create the Development VPC
# resource "aws_vpc" "dev" {
#   cidr_block           = var.dev_vpc_cidr
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name        = "dev-vpc"
#     Environment = "development"
#     Project     = var.environment
#   }
# }


# # ========================= DEFINE SUBNETS ==============================================================
# # Create subnets for Production VPC
# resource "aws_subnet" "prod_private" {
#   count             = length(var.availability_zones)
#   vpc_id            = aws_vpc.prod.id
#   cidr_block        = cidrsubnet(var.prod_vpc_cidr, 8, count.index)
#   availability_zone = var.availability_zones[count.index]

#   tags = {
#     Name        = "prod-private-${var.availability_zones[count.index]}"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# resource "aws_subnet" "prod_public" {
#   count                   = length(var.availability_zones)
#   vpc_id                  = aws_vpc.prod.id
#   cidr_block              = cidrsubnet(var.prod_vpc_cidr, 8, count.index + 10)
#   availability_zone       = var.availability_zones[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name        = "prod-public-${var.availability_zones[count.index]}"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# # Create subnets for Development VPC
# resource "aws_subnet" "dev_private" {
#   count             = length(var.availability_zones)
#   vpc_id            = aws_vpc.dev.id
#   cidr_block        = cidrsubnet(var.dev_vpc_cidr, 8, count.index)
#   availability_zone = var.availability_zones[count.index]

#   tags = {
#     Name        = "dev-private-${var.availability_zones[count.index]}"
#     Environment = "development"
#     Project     = var.environment
#   }
# }

# resource "aws_subnet" "dev_public" {
#   count                   = length(var.availability_zones)
#   vpc_id                  = aws_vpc.dev.id
#   cidr_block              = cidrsubnet(var.dev_vpc_cidr, 8, count.index + 10)
#   availability_zone       = var.availability_zones[count.index]
#   map_public_ip_on_launch = true

#   tags = {
#     Name        = "dev-public-${var.availability_zones[count.index]}"
#     Environment = "development"
#     Project     = var.environment
#   }
# }

# # ========================= DEFINE INTERNET GATEWAYs ==========================================================
# # Create Internet Gateways
# resource "aws_internet_gateway" "prod_igw" {
#   vpc_id = aws_vpc.prod.id

#   tags = {
#     Name        = "prod-igw"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# resource "aws_internet_gateway" "dev_igw" {
#   vpc_id = aws_vpc.dev.id

#   tags = {
#     Name        = "dev-igw"
#     Environment = "development"
#     Project     = var.environment
#   }
# }


# # ============================== DEFINE TRANSIT GATEWAY  and ATTACHMENTS ==========================================================
# # Create Transit Gateway
# resource "aws_ec2_transit_gateway" "tgw" {
#   description                     = "Transit Gateway for multi-environment architecture"
#   default_route_table_association = "enable"
#   default_route_table_propagation = "enable"
#   auto_accept_shared_attachments  = "disable"

#   tags = {
#     Name    = "multi-env-tgw"
#     Project = var.environment
#   }
# }

# # Attach Production VPC to Transit Gateway
# resource "aws_ec2_transit_gateway_vpc_attachment" "prod_tgw_attachment" {
#   subnet_ids         = aws_subnet.prod_private[*].id
#   transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   vpc_id             = aws_vpc.prod.id

#   tags = {
#     Name        = "prod-tgw-attachment"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# # Attach Development VPC to Transit Gateway
# resource "aws_ec2_transit_gateway_vpc_attachment" "dev_tgw_attachment" {
#   subnet_ids         = aws_subnet.dev_private[*].id
#   transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   vpc_id             = aws_vpc.dev.id

#   tags = {
#     Name        = "dev-tgw-attachment"
#     Environment = "development"
#     Project     = var.environment
#   }
# }

# # ============================== DEFINE ROUTE TABLES ==========================================================
# # Create Route Tables for Production VPC
# resource "aws_route_table" "prod_public" {
#   vpc_id = aws_vpc.prod.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.prod_igw.id
#   }

#   # Route to Development VPC via Transit Gateway
#   route {
#     cidr_block         = var.dev_vpc_cidr
#     transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   }

#   tags = {
#     Name        = "prod-public-rt"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# resource "aws_route_table" "prod_private" {
#   vpc_id = aws_vpc.prod.id

#   # Route to Development VPC via Transit Gateway
#   route {
#     cidr_block         = var.dev_vpc_cidr
#     transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   }

#   tags = {
#     Name        = "prod-private-rt"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# # Create Route Tables for Development VPC
# resource "aws_route_table" "dev_public" {
#   vpc_id = aws_vpc.dev.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.dev_igw.id
#   }

#   # Route to Production VPC via Transit Gateway
#   route {
#     cidr_block         = var.prod_vpc_cidr
#     transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   }

#   tags = {
#     Name        = "dev-public-rt"
#     Environment = "development"
#     Project     = var.environment
#   }
# }

# resource "aws_route_table" "dev_private" {
#   vpc_id = aws_vpc.dev.id

#   # Route to Production VPC via Transit Gateway
#   route {
#     cidr_block         = var.prod_vpc_cidr
#     transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#   }

#   tags = {
#     Name        = "dev-private-rt"
#     Environment = "development"
#     Project     = var.environment
#   }
# }

# # Associate Route Tables with Subnets
# resource "aws_route_table_association" "prod_public" {
#   count          = length(var.availability_zones)
#   subnet_id      = aws_subnet.prod_public[count.index].id
#   route_table_id = aws_route_table.prod_public.id
# }

# resource "aws_route_table_association" "prod_private" {
#   count          = length(var.availability_zones)
#   subnet_id      = aws_subnet.prod_private[count.index].id
#   route_table_id = aws_route_table.prod_private.id
# }

# resource "aws_route_table_association" "dev_public" {
#   count          = length(var.availability_zones)
#   subnet_id      = aws_subnet.dev_public[count.index].id
#   route_table_id = aws_route_table.dev_public.id
# }

# resource "aws_route_table_association" "dev_private" {
#   count          = length(var.availability_zones)
#   subnet_id      = aws_subnet.dev_private[count.index].id
#   route_table_id = aws_route_table.dev_private.id
# }


# # ============================== DEFINE NETWORK ACLs ==========================================================
# # Production Network ACLs
# resource "aws_network_acl" "prod_private" {
#   vpc_id     = aws_vpc.prod.id
#   subnet_ids = aws_subnet.prod_private[*].id

#   # Allow internal traffic
#   ingress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = var.prod_vpc_cidr
#     from_port  = 0
#     to_port    = 0
#   }

#   # Allow traffic from dev VPC
#   ingress {
#     protocol   = -1
#     rule_no    = 110
#     action     = "allow"
#     cidr_block = var.dev_vpc_cidr
#     from_port  = 0
#     to_port    = 0
#   }

#   # Allow return traffic
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 120
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#   }

#   # Allow all outbound traffic
#   egress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }

#   tags = {
#     Name        = "prod-private-nacl"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# # Development Network ACLs
# resource "aws_network_acl" "dev_private" {
#   vpc_id     = aws_vpc.dev.id
#   subnet_ids = aws_subnet.dev_private[*].id

#   # Allow internal traffic
#   ingress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = var.dev_vpc_cidr
#     from_port  = 0
#     to_port    = 0
#   }

#   # Allow traffic from prod VPC but limit to specific protocols
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 110
#     action     = "allow"
#     cidr_block = var.prod_vpc_cidr
#     from_port  = 22
#     to_port    = 22
#   }

#   # Allow HTTP/HTTPS from prod VPC 
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 120
#     action     = "allow"
#     cidr_block = var.prod_vpc_cidr
#     from_port  = 80
#     to_port    = 80
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 130
#     action     = "allow"
#     cidr_block = var.prod_vpc_cidr
#     from_port  = 443
#     to_port    = 443
#   }

#   # Allow return traffic
#   ingress {
#     protocol   = "tcp"
#     rule_no    = 140
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1024
#     to_port    = 65535
#   }

#   # Allow all outbound
#   egress {
#     protocol   = -1
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }

#   tags = {
#     Name        = "dev-private-nacl"
#     Environment = "development"
#     Project     = var.environment
#   }
# }



# # ============================== DEFINE SECURITY GROUPs ==========================================================
# # Production Security Groups
# resource "aws_security_group" "prod_app" {
#   name        = "prod-app-sg"
#   description = "Security group for production application servers"
#   vpc_id      = aws_vpc.prod.id

#   # Allow HTTPS from anywhere
#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow HTTPS from anywhere"
#   }

#   # Allow SSH only from within VPC
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.prod_vpc_cidr]
#     description = "Allow SSH from within VPC"
#   }

#   # Allow all outbound
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

#   tags = {
#     Name        = "prod-app-sg"
#     Environment = "production"
#     Project     = var.environment
#   }
# }

# # Development Security Groups
# resource "aws_security_group" "dev_app" {
#   name        = "dev-app-sg"
#   description = "Security group for development application servers"
#   vpc_id      = aws_vpc.dev.id

#   # Allow HTTP/HTTPS only from Production VPC
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [var.prod_vpc_cidr]
#     description = "Allow HTTP from Production VPC"
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = [var.prod_vpc_cidr]
#     description = "Allow HTTPS from Production VPC"
#   }

#   # Allow SSH from Production VPC
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.prod_vpc_cidr]
#     description = "Allow SSH from Production VPC"
#   }

#   # Allow all outbound
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow all outbound traffic"
#   }

#   tags = {
#     Name        = "dev-app-sg"
#     Environment = "development"
#     Project     = var.environment
#   }
# }


# ======================================================================================================================




# Create Production VPC
module "prod_vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.prod_vpc_cidr
  environment        = "production"
  availability_zones = var.availability_zones

  tags = {
    Environment = "production"
    Project     = var.environment
  }
}

# Create Development VPC
module "dev_vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.dev_vpc_cidr
  environment        = "development"
  availability_zones = var.availability_zones

  tags = {
    Environment = "development"
    Project     = var.environment
  }
}

# Create Transit Gateway with attachments
module "transit_gateway" {
  source = "./modules/transit-gateway"

  name        = "multi-env-tgw"
  description = "Transit Gateway for multi-environment architecture"

  vpc_attachments = {
    prod = {
      vpc_id      = module.prod_vpc.vpc_id
      subnet_ids  = module.prod_vpc.private_subnet_ids
      environment = "production"
    }
    dev = {
      vpc_id      = module.dev_vpc.vpc_id
      subnet_ids  = module.dev_vpc.private_subnet_ids
      environment = "development"
    }
  }

  vpc_routes = {
    # Production routes to Dev
    prod_to_dev_public = {
      route_table_id         = module.prod_vpc.public_route_table_id
      destination_cidr_block = var.dev_vpc_cidr
    }
    prod_to_dev_private = {
      route_table_id         = module.prod_vpc.private_route_table_id
      destination_cidr_block = var.dev_vpc_cidr
    }
    # Development routes to Prod
    dev_to_prod_public = {
      route_table_id         = module.dev_vpc.public_route_table_id
      destination_cidr_block = var.prod_vpc_cidr
    }
    dev_to_prod_private = {
      route_table_id         = module.dev_vpc.private_route_table_id
      destination_cidr_block = var.prod_vpc_cidr
    }
  }

  tags = {
    Project = var.environment
  }
}

# Security configurations
module "security" {
  source = "./modules/security"

  security_groups = {
    prod_app = {
      name        = "prod-app-sg"
      description = "Security group for production application servers"
      vpc_id      = module.prod_vpc.vpc_id
      ingress_rules = {
        https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow HTTPS from anywhere"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [var.prod_vpc_cidr]
          description = "Allow SSH from within VPC"
        }
      }
      egress_rules = {
        all = {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound traffic"
        }
      }
      tags = {
        Environment = "production"
      }
    }
    dev_app = {
      name        = "dev-app-sg"
      description = "Security group for development application servers"
      vpc_id      = module.dev_vpc.vpc_id
      ingress_rules = {
        http = {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = [var.prod_vpc_cidr]
          description = "Allow HTTP from Production VPC"
        }
        https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = [var.prod_vpc_cidr]
          description = "Allow HTTPS from Production VPC"
        }
        ssh = {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [var.prod_vpc_cidr]
          description = "Allow SSH from Production VPC"
        }
      }
      egress_rules = {
        all = {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
          description = "Allow all outbound traffic"
        }
      }
      tags = {
        Environment = "development"
      }
    }
  }

  network_acls = {
    prod_private = {
      name       = "prod-private-nacl"
      vpc_id     = module.prod_vpc.vpc_id
      subnet_ids = module.prod_vpc.private_subnet_ids
      ingress_rules = {
        internal = {
          rule_number = 100
          protocol    = "-1"
          action      = "allow"
          cidr_block  = var.prod_vpc_cidr
          from_port   = 0
          to_port     = 0
        }
        from_dev = {
          rule_number = 110
          protocol    = "-1"
          action      = "allow"
          cidr_block  = var.dev_vpc_cidr
          from_port   = 0
          to_port     = 0
        }
        return_traffic = {
          rule_number = 120
          protocol    = "tcp"
          action      = "allow"
          cidr_block  = "0.0.0.0/0"
          from_port   = 1024
          to_port     = 65535
        }
      }
      egress_rules = {
        all = {
          rule_number = 100
          protocol    = "-1"
          action      = "allow"
          cidr_block  = "0.0.0.0/0"
          from_port   = 0
          to_port     = 0
        }
      }
      tags = {
        Environment = "production"
      }
    }
    dev_private = {
      name       = "dev-private-nacl"
      vpc_id     = module.dev_vpc.vpc_id
      subnet_ids = module.dev_vpc.private_subnet_ids
      ingress_rules = {
        internal = {
          rule_number = 100
          protocol    = "-1"
          action      = "allow"
          cidr_block  = var.dev_vpc_cidr
          from_port   = 0
          to_port     = 0
        }
        ssh_from_prod = {
          rule_number = 110
          protocol    = "tcp"
          action      = "allow"
          cidr_block  = var.prod_vpc_cidr
          from_port   = 22
          to_port     = 22
        }
        http_from_prod = {
          rule_number = 120
          protocol    = "tcp"
          action      = "allow"
          cidr_block  = var.prod_vpc_cidr
          from_port   = 80
          to_port     = 80
        }
        https_from_prod = {
          rule_number = 130
          protocol    = "tcp"
          action      = "allow"
          cidr_block  = var.prod_vpc_cidr
          from_port   = 443
          to_port     = 443
        }
        return_traffic = {
          rule_number = 140
          protocol    = "tcp"
          action      = "allow"
          cidr_block  = "0.0.0.0/0"
          from_port   = 1024
          to_port     = 65535
        }
      }
      egress_rules = {
        all = {
          rule_number = 100
          protocol    = "-1"
          action      = "allow"
          cidr_block  = "0.0.0.0/0"
          from_port   = 0
          to_port     = 0
        }
      }
      tags = {
        Environment = "development"
      }
    }
  }

  tags = {
    Project = var.environment
  }
}


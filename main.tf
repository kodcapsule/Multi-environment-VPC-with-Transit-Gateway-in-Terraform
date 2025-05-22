# Create the Production VPC
resource "aws_vpc" "prod" {
  cidr_block           = var.prod_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "prod-vpc"
    Environment = "production"
    Project     = var.environment
  }
}

# Create the Development VPC
resource "aws_vpc" "dev" {
  cidr_block           = var.dev_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "dev-vpc"
    Environment = "development"
    Project     = var.environment
  }
}

# Create subnets for Production VPC
resource "aws_subnet" "prod_private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.prod.id
  cidr_block        = cidrsubnet(var.prod_vpc_cidr, 8, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "prod-private-${var.availability_zones[count.index]}"
    Environment = "production"
    Project     = var.environment
  }
}

resource "aws_subnet" "prod_public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.prod.id
  cidr_block        = cidrsubnet(var.prod_vpc_cidr, 8, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "prod-public-${var.availability_zones[count.index]}"
    Environment = "production"
    Project     = var.environment
  }
}

# Create subnets for Development VPC
resource "aws_subnet" "dev_private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.dev.id
  cidr_block        = cidrsubnet(var.dev_vpc_cidr, 8, count.index)
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "dev-private-${var.availability_zones[count.index]}"
    Environment = "development"
    Project     = var.environment
  }
}

resource "aws_subnet" "dev_public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.dev.id
  cidr_block        = cidrsubnet(var.dev_vpc_cidr, 8, count.index + 10)
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "dev-public-${var.availability_zones[count.index]}"
    Environment = "development"
    Project     = var.environment
  }
}

# Create Internet Gateways
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name        = "prod-igw"
    Environment = "production"
    Project     = var.environment
  }
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name        = "dev-igw"
    Environment = "development"
    Project     = var.environment
  }
}

# Create Transit Gateway
resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Transit Gateway for multi-environment architecture"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "disable"

  tags = {
    Name    = "multi-env-tgw"
    Project = var.environment
  }
}
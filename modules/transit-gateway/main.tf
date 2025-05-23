# modules/transit-gateway/main.tf
resource "aws_ec2_transit_gateway" "main" {
  description                     = var.description
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "attachments" {
  for_each = var.vpc_attachments

  subnet_ids         = each.value.subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = each.value.vpc_id

  tags = merge(var.tags, {
    Name        = "${each.key}-tgw-attachment"
    Environment = each.value.environment
  })
}

# Add routes to VPC route tables
resource "aws_route" "vpc_routes" {
  for_each = var.vpc_routes

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.main.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.attachments]
}

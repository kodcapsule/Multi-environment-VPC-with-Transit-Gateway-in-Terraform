# modules/security/main.tf

# Security Groups
resource "aws_security_group" "main" {
  for_each = var.security_groups

  name        = each.value.name
  description = each.value.description
  vpc_id      = each.value.vpc_id

  tags = merge(var.tags, each.value.tags, {
    Name = each.value.name
  })
}

resource "aws_security_group_rule" "ingress" {
  for_each = local.ingress_rules

  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  security_group_id = aws_security_group.main[each.value.sg_key].id
}

resource "aws_security_group_rule" "egress" {
  for_each = local.egress_rules

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  security_group_id = aws_security_group.main[each.value.sg_key].id
}

# Network ACLs
resource "aws_network_acl" "main" {
  for_each = var.network_acls

  vpc_id     = each.value.vpc_id
  subnet_ids = each.value.subnet_ids

  tags = merge(var.tags, each.value.tags, {
    Name = each.value.name
  })
}

resource "aws_network_acl_rule" "ingress" {
  for_each = local.nacl_ingress_rules

  network_acl_id = aws_network_acl.main[each.value.nacl_key].id
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

resource "aws_network_acl_rule" "egress" {
  for_each = local.nacl_egress_rules

  network_acl_id = aws_network_acl.main[each.value.nacl_key].id
  rule_number    = each.value.rule_number
  protocol       = each.value.protocol
  rule_action    = each.value.action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
}

# modules/security/locals.tf
locals {
  # Flatten security group ingress rules
  ingress_rules = {
    for rule in flatten([
      for sg_key, sg in var.security_groups : [
        for rule_key, rule in sg.ingress_rules : {
          key         = "${sg_key}-ingress-${rule_key}"
          sg_key      = sg_key
          from_port   = rule.from_port
          to_port     = rule.to_port
          protocol    = rule.protocol
          cidr_blocks = rule.cidr_blocks
          description = rule.description
        }
      ]
    ]) : rule.key => rule
  }

  # Flatten security group egress rules
  egress_rules = {
    for rule in flatten([
      for sg_key, sg in var.security_groups : [
        for rule_key, rule in sg.egress_rules : {
          key         = "${sg_key}-egress-${rule_key}"
          sg_key      = sg_key
          from_port   = rule.from_port
          to_port     = rule.to_port
          protocol    = rule.protocol
          cidr_blocks = rule.cidr_blocks
          description = rule.description
        }
      ]
    ]) : rule.key => rule
  }

  # Flatten NACL ingress rules
  nacl_ingress_rules = {
    for rule in flatten([
      for nacl_key, nacl in var.network_acls : [
        for rule_key, rule in nacl.ingress_rules : {
          key         = "${nacl_key}-ingress-${rule_key}"
          nacl_key    = nacl_key
          rule_number = rule.rule_number
          protocol    = rule.protocol
          action      = rule.action
          cidr_block  = rule.cidr_block
          from_port   = rule.from_port
          to_port     = rule.to_port
        }
      ]
    ]) : rule.key => rule
  }

  # Flatten NACL egress rules
  nacl_egress_rules = {
    for rule in flatten([
      for nacl_key, nacl in var.network_acls : [
        for rule_key, rule in nacl.egress_rules : {
          key         = "${nacl_key}-egress-${rule_key}"
          nacl_key    = nacl_key
          rule_number = rule.rule_number 
          protocol    = rule.protocol
          action      = rule.action
          cidr_block  = rule.cidr_block
          from_port   = rule.from_port
          to_port     = rule.to_port
        }
      ]
    ]) : rule.key => rule
  }
}

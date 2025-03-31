resource "aws_db_instance" "this" {
  for_each = var.db_instances

  identifier          = each.value.db_identifier
  engine              = each.value.db_engine
  engine_version      = each.value.db_engine_version
  instance_class      = each.value.db_instance_class
  allocated_storage   = each.value.db_allocated_storage
  storage_type        = each.value.db_storage_type
  multi_az            = each.value.multi_az
  publicly_accessible = each.value.publicly_accessible

  db_name                = each.value.db_name
  username               = each.value.db_username
  password               = each.value.db_password
  parameter_group_name   = aws_db_parameter_group.this[each.key].name
  vpc_security_group_ids = [aws_security_group.this[each.key].id]
  db_subnet_group_name   = aws_db_subnet_group.this[each.key].name

  skip_final_snapshot = each.value.skip_final_snapshot
  deletion_protection = each.value.deletion_protection

  tags = each.value.tags
}

resource "aws_db_subnet_group" "this" {
  for_each = var.db_instances

  name       = "${each.value.db_identifier}-subnet-group"
  subnet_ids = each.value.subnet_ids

  tags = {
    Name = "${each.value.db_identifier}-subnet-group"
  }
}

resource "aws_db_parameter_group" "this" {
  for_each = var.db_instances

  name   = "${each.value.db_identifier}-param-group"
  family = each.value.db_parameter_group_family

  dynamic "parameter" {
    for_each = each.value.db_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

resource "aws_security_group" "this" {
  for_each = var.db_instances

  name        = "${each.value.db_identifier}-sg"
  description = "Security group for ${each.value.db_identifier} RDS instance"
  vpc_id      = each.value.vpc_id

  dynamic "ingress" {
    for_each = each.value.allowed_ingress_cidrs
    content {
      from_port   = each.value.db_port
      to_port     = each.value.db_port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

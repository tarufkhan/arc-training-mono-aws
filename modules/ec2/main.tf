resource "aws_security_group" "sg" {
  for_each = { for idx, inst in var.instances : idx => inst if inst.create_sg }
  name     = "${each.value.name}-sg"
  vpc_id   = data.aws_vpc.selected.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ─── EC2 Instances ──────────────────────────────────────────────────────────
resource "aws_instance" "ec2" {
  for_each      = { for idx, inst in var.instances : idx => inst }
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = each.value.instance_type
  subnet_id     = data.aws_subnets.selected.ids[0]
  associate_public_ip_address = each.value.associate_public_ip

  vpc_security_group_ids = each.value.create_sg ? [aws_security_group.sg[each.key].id] : []

  tags = {
    Name = each.value.name
  }
}
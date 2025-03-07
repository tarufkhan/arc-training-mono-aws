# Create VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(var.tags, { Name = var.vpc_name })
}

# Create Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.vpc_name}-igw" })
}

# Create Public Subnets
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = var.azs[each.key]

  tags = merge(var.tags, { Name = "${var.vpc_name}-public-${each.key}" })
}

# Create Private Subnets
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.azs[each.key]

  tags = merge(var.tags, { Name = "${var.vpc_name}-private-${each.key}" })
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateway ? aws_subnet.public : {}

  domain = "vpc"

  tags = merge(var.tags, { Name = "${var.vpc_name}-nat-${each.key}" })
}

# Create NAT Gateways
resource "aws_nat_gateway" "this" {
  for_each = var.enable_nat_gateway ? aws_subnet.public : {}

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(var.tags, { Name = "${var.vpc_name}-nat-${each.key}" })

  depends_on = [aws_internet_gateway.this]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.vpc_name}-public-rt" })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.vpc_name}-private-rt-${each.key}" })
}

resource "aws_route" "private_nat_gateway" {
  for_each = var.enable_nat_gateway ? aws_subnet.private : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.key % length(aws_nat_gateway.this)].id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

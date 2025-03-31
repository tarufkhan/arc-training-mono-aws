output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.private : s.id]
}

output "nat_gateways" {
  description = "List of NAT Gateway IDs"
  value       = var.enable_nat_gateway ? [for nat in aws_nat_gateway.this : nat.id] : []
}

output "igw_gateways" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.this.id
}

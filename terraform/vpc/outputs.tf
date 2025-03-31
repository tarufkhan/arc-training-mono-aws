output "" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "nat_gateways" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.nat_gateways
}

output "igw_gateway" {
  description = "The ID of the internet gateway"
  value       = module.vpc.igw_gateways
}
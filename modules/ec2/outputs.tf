output "security_group_ids" {
  description = "List of security group IDs created"
  value       = { for idx, sg in aws_security_group.sg : idx => sg.id }
}

output "vpc_id" {
  description = "VPC ID used for deployment"
  value       = data.aws_vpc.selected.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = data.aws_subnets.selected.ids
}

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = { for idx, instance in aws_instance.ec2 : idx => instance.id }
}

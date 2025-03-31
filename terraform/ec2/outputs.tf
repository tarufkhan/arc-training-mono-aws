output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = module.ec2.instance_ids
}

output "sg_ids" {
  description = "Security Group attached to the EC2 instances"
  value       = module.ec2.security_group_ids
}

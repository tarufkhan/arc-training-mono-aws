output "db_endpoints" {
  description = "RDS instance endpoints"
  value       = { for k, v in aws_db_instance.this : k => v.endpoint }
}

output "db_instance_ids" {
  description = "RDS instance IDs"
  value       = { for k, v in aws_db_instance.this : k => v.id }
}

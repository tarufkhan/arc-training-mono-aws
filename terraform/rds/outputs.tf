output "db_endpoints" {
  description = "Endpoints of the Databases"
  value       = module.rds.db_endpoints
}

output "db_instance_ids" {
  description = "The IDs of the Db instances"
  value       = module.rds.db_instance_ids
}
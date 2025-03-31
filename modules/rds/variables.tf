variable "db_instances" {
  description = "Map of RDS instances to create"
  type = map(object({
    db_identifier        = string
    db_engine            = string
    db_engine_version    = string
    db_instance_class    = string
    db_allocated_storage = number
    db_storage_type      = string
    multi_az             = bool
    publicly_accessible  = bool

    db_name     = string
    db_username = string
    db_password = string
    db_port     = number

    db_parameter_group_family = string
    db_parameters             = map(string)

    vpc_id                = string
    subnet_ids            = list(string)
    allowed_ingress_cidrs = list(string)

    skip_final_snapshot = bool
    deletion_protection = bool

    tags = map(string)
  }))
}

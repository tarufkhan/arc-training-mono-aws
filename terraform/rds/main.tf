resource "random_password" "postgres" {
  length = 20
  special = false
}

resource "random_password" "mysql" {
  length = 24
  special = true
}

module "rds" {
  source = "../../modules/rds"

  db_instances = {
    "db1" = {
      db_identifier        = "db-instance-1"
      db_engine            = "postgres"
      db_engine_version    = "14.12"
      db_instance_class    = "db.t3.micro"
      db_allocated_storage = 20
      db_storage_type      = "gp2"
      multi_az             = false
      publicly_accessible  = false

      db_name     = "maindb1"
      db_username = "db_user"
      db_password = random_password.postgres.result
      db_port     = 5432

      db_parameter_group_family = "postgres14"
      db_parameters = {
        "log_statement" = "all"
        "work_mem"      = "4096"
      }

      vpc_id                = data.aws_vpc.this.id
      subnet_ids            = data.aws_subnets.this.ids
      allowed_ingress_cidrs = ["10.0.0.0/16"]

      skip_final_snapshot = true
      deletion_protection = false

      tags = {
        Environment = "dev"
        Project     = "my-project"
      }
    }

    "db2" = {
      db_identifier        = "db-instance-2"
      db_engine            = "mysql"
      db_engine_version    = "8.0"
      db_instance_class    = "db.t3.small"
      db_allocated_storage = 50
      db_storage_type      = "gp2"
      multi_az             = true
      publicly_accessible  = false

      db_name     = "maindb2"
      db_username = "db_user"
      db_password = random_password.mysql.result
      db_port     = 3306

      db_parameter_group_family = "mysql8.0"
      db_parameters = {
        "slow_query_log"  = "1"
        "long_query_time" = "2"
      }

      vpc_id                = data.aws_vpc.this.id
      subnet_ids            = data.aws_subnets.this.ids
      allowed_ingress_cidrs = ["10.1.0.0/16"]

      skip_final_snapshot = true
      deletion_protection = true

      tags = {
        Environment = "prod"
        Project     = "my-project"
      }
    }
  }
}

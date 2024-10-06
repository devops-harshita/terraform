rds_name              = "demo-db"
private_subnet_tag    = "private"
environment           = "dev"
engine_version        = "8.0.35"
major_engine_version  = "8.0"
instance_class        = "db.t3.micro"
allocated_storage     = 20
max_allocated_storage = 30
db_name               = "initial_db"
family                = "mysql8.0"
monitoring_role_name  = "dashboard-rds-monitoring-role"
tags = {
  Project = "demo-project"
}
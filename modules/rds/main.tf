terraform {
  backend "s3" {
    bucket         = "demo-project-remote-backend"
    region         = "us-west-2"
    dynamodb_table = "terraform_locks"
  }
}
module "db_instance" {
  source                              = "terraform-aws-modules/rds/aws"
  version                             = "v6.1.1"
  create_db_instance                  = var.create_db_instance
  identifier                          = var.rds_name
  create_db_option_group              = var.create_db_option_group
  create_db_parameter_group           = var.create_db_parameter_group
  engine                              = var.engine
  engine_version                      = var.engine_version
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  max_allocated_storage               = var.max_allocated_storage
  db_name                             = var.db_name
  username                            = var.username
  port                                = var.port
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  vpc_security_group_ids              = [module.security_group.security_group_id]
  monitoring_role_name                = var.monitoring_role_name
  create_monitoring_role              = var.create_monitoring_role
  tags                                = var.tags
  create_db_subnet_group              = var.create_db_subnet_group
  subnet_ids                          = data.aws_subnets.private.ids
  family                              = var.family
  major_engine_version                = var.allow_major_version_upgrade
  deletion_protection                 = var.deletion_protection
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = var.rds_name
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL access from within VPC"
      cidr_blocks = var.vpc_cidr_block
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL All traffic Outbound"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = var.tags
}
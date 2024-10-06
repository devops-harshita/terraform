terraform {
  backend "s3" {
    bucket         = "demo-project-remote-backend"
    region         = "us-west-2"
    dynamodb_table = "terraform_locks"
  }
}
module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "v5.1.1"
  name            = var.vpc_name
  cidr            = var.vpc_cidr_block
  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1",
    "Tier"                            = var.private_subnet_tag
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "Tier"                   = var.public_subnet_tag
  }
  enable_nat_gateway       = true
  enable_vpn_gateway       = false
  enable_dhcp_options      = true
  dhcp_options_domain_name = "us-west-2.compute.internal"

  tags = {
    Environment = var.environment
  }
}
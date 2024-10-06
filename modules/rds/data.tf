data "aws_subnets" "private" {
  filter {
    name   = "tag:Tier"
    values = [var.private_subnet_tag]
  }
}

data "aws_availability_zones" "available" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "demo-project-remote-backend"
    key    = "${var.environment}/vpc/terraform.tfstate"
    region = var.aws_region
  }
}
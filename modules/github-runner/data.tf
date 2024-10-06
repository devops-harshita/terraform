data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230325"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Tier"
    values = ["public"]
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
terraform {
  backend "s3" {
    bucket         = "demo-project-remote-backend"
    region         = "us-west-2"
    dynamodb_table = "terraform_locks"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "v7.4.1"
  name    = var.name

  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  user_data           = base64encode(var.userdata)
  health_check_type   = var.health_check_type
  vpc_zone_identifier = data.aws_subnets.public.ids
  maintenance_options = {
    auto_recovery = "default"
  }
  initial_lifecycle_hooks     = var.initial_lifecycle_hooks
  create_iam_instance_profile = true
  iam_role_name               = var.iam_role_name
  iam_role_policies           = var.iam_role_policies
  instance_refresh            = var.instance_refresh

  # Launch template
  launch_template_name        = var.launch_template
  launch_template_description = "Launch Template for github runner"
  update_default_version      = true
  image_id                    = data.aws_ami.ubuntu.id
  key_name                    = var.key_name
  instance_type               = var.instance_type
  ebs_optimized               = var.ebs_optimized
  enable_monitoring           = true

  block_device_mappings = var.block_device_mappings
  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  cpu_options = {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification = {
    cpu_credits = "standard"
  }

  metadata_options = var.metadata_options

  network_interfaces = [
    {
      associate_public_ip_address = true
      delete_on_termination       = true
      description                 = "eth0"
      device_index                = 0
      security_groups             = [module.sg.security_group_id]
    }
  ]

  placement = {
    availability_zone = "us-west-2a"
  }

  tag_specifications = var.tag_specifications

  tags = var.tags
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v5.1.0"

  name        = "github-runner-asg-sg"
  description = "asg-github-runner ec2 sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH from Anywhere"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "SSM Outbound"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = var.tags
}
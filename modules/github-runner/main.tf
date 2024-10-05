data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
module "ec2_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  key_name               = "harshita"
  associate_public_ip_address = true
  name                   = "github-runner"
  create_iam_instance_profile = true
  iam_role_name          = "ec2-ssm"
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  monitoring             = false
  vpc_security_group_ids = [module.aws_sg.security_group_id]
  subnet_id              = "subnet-00829907bb3a5414c"
  user_data              = <<EOF
  mkdir actions-runner && cd actions-runner
  curl -o actions-runner-linux-x64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz
  echo "3f6efb7488a183e291fc2c62876e14c9ee732864173734facc85a1bfb1744464  actions-runner-linux-x64-2.319.1.tar.gz" | shasum -a 256 -c
  tar xzf ./actions-runner-linux-x64-2.319.1.tar.gz
  ./config.sh --url https://github.com/devops-harshita/terraform --token BKOHPKWXCS22NSPBCK5XGJTHAFWF2
  ./run.sh
  sudo ./svc.sh install
  sudo ./svc.sh start
  echo "Docker Installation Begins!"
  # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo chmod 666 /var/run/docker.sock
  apt install terraform
  apt install docker
  EOF
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "aws_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "gitlab-sg"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-0f4cf75d17046431c"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  #   ingress_rules            = ["tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules= [
      "all-all"
    ]
}
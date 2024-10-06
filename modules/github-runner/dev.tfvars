environment      = "dev"
name             = "github-runner"
launch_template  = "github-runner-template"
min_size         = 1
max_size         = 2
desired_capacity = 1
iam_role_name    = "github-runner-role"
userdata         = <<-EOF
#!/bin/bash
mkdir -p /home/ubuntu/dependencies && cd /home/ubuntu/dependencies/
echo "Install Docker"
apt update && apt install unzip && apt install jq -y
apt install docker.io -y >> docker-output.log
systemctl start docker
sudo usermod -aG docker ubuntu
echo "Install Terraform"
curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y
apt install terraform
echo "Install aws cli v2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
echo "Setup Github Runner"
mkdir -p /actions-runner && cd /actions-runner/
curl -o actions-runner-linux-x64-2.309.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.309.0/actions-runner-linux-x64-2.309.0.tar.gz
echo "2974243bab2a282349ac833475d241d5273605d3628f0685bd07fb5530f9bb1a  actions-runner-linux-x64-2.309.0.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.309.0.tar.gz
chown ubuntu -R /actions-runner
token "BKOHPKS62YM2PWBN5LCVIFTHAKWKE"
sudo -u ubuntu ./config.sh --url https://github.com/devops-harshita/terraform --token $token --name "runner-$(hostname)" --work _work --labels default --runnergroup default --unattended
./run.sh --once
./svc.sh install
./svc.sh start

EOF
tags = {
  Project = "demo-project"
}

environment = "dev"
vpc_name    = "demo-dev"
cidr        = "172.25.128.0/18"

azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
private_subnets = ["172.25.128.0/21", "172.25.136.0/21", "172.25.144.0/21", "172.25.152.0/21"]
public_subnets  = ["172.25.160.0/21", "172.25.168.0/21", "172.25.176.0/21", "172.25.184.0/21"]
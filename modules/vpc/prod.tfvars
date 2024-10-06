environment        = "prod"
vpc_name           = "dashboard-prod"
vpc_cidr_block     = "172.16.0.0/18"
private_subnet_tag = "prod-private"
public_subnet_tag  = "prod-public"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
private_subnets    = ["172.16.0.0/21", "172.16.8.0/21", "172.16.16.0/21"]
public_subnets     = ["172.16.32.0/21", "172.16.40.0/21", "172.16.48.0/21"]
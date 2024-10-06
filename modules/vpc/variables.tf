variable "environment" {
}

#VPC
variable "vpc_name" {
}

variable "private_subnet_tag" {
  default = "private"
}
variable "public_subnet_tag" {
  default = "public"
}

variable "vpc_cidr_block" {
  default = "172.25.128.0/18"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-west-2a","us-west-2b","us-west-2c"]
  description = "List of Availability Zones"
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
}
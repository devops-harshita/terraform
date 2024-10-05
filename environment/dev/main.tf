module "vpc" {
  source      = "../../modules/vpc"
  environment = "dev"
}
module "github-runner" {
  source = "../../modules/github-runner"
}
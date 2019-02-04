data "terraform_remote_state" "eip" {
  backend = "s3"

  config {
    bucket = "${var.remote_bucket_name}"
    region = "us-west-2"
    key = "eip/eip.tfstate"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  single_nat_gateway      = false
  one_nat_gateway_per_az  = false
  reuse_nat_ips           = false
  external_nat_ip_ids     = []
  enable_dns_hostnames    = true
  enable_dns_support      = true

  tags = {
    Terraform = "true"
    Environment = "${var.vpc_env}"
  }
}
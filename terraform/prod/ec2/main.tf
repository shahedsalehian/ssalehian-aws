
terraform {
  backend "s3" {
    bucket = "ssalehian-state-bucket"
    dynamodb_table = "ssalehian-state-lock"
    key    = "ec2/ec2.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region  = "us-west-2"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ssalehian-state-bucket"
    region = "us-west-2"
    key = "vpc/vpc.tfstate"
  }
}
data "aws_caller_identity" "current" {}
data "aws_ami" "ssalehian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ssalehian-ami *"]
  }

  owners = ["${data.aws_caller_identity.current.account_id}"]
}
module "ec2" {
  source = "../../modules/ec2"

  ami = "${data.aws_ami.ssalehian.id}"
  subnet_id = "${data.terraform_remote_state.vpc.public_subnets[0]}"
  instance_type = "t2.micro"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
}

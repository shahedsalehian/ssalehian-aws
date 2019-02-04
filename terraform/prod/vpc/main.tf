terraform {
  backend "s3" {
    bucket = "ssalehian-state-bucket"
    dynamodb_table = "ssalehian-state-lock"
    key    = "vpc/vpc.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region  = "us-west-2"
}

module "vpc" {
  source = "../../modules/vpc"
  
  vpc_name = "ssalehian-vpc"
  vpc_env = "prod"
  remote_bucket_name = "ssalehian-state-bucket"
}
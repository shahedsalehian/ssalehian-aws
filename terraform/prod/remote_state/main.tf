provider "aws" {
  region  = "us-west-2"
}

module "remote_state" {
  source = "../../modules/remote_state"

  bucket_name = "ssalehian-state-bucket"
  table_name = "ssalehian-state-lock"
}
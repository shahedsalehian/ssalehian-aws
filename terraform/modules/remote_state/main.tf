resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "${var.bucket_name}"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name            = "${var.table_name}"
  read_capacity   = 1
  write_capacity  = 1
  hash_key        = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
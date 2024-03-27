resource "aws_dynamodb_table" "state_lock" {
  name = "state_lock"
  hash_key = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "finance" {
  bucket = "terraform-d99-finance"
  tags = {
    Description = "Bucket for finance"
  }
}
terraform {
  backend "s3" {
    bucket = "terraform-d99-finance"
    key = "finance/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "state_lock"
  }
}
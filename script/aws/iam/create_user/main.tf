provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "terraform_user" {
  name = "terry"
  tags = {
    Description = "Terry Torry"
  }
}

resource "aws_iam_policy" "admin_user" {
  name   = "Admin"
  policy = file("./admin-policy.json")
}

resource "aws_iam_user_policy_attachment" "terraform_user_access" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.admin_user.arn
}
resource "aws_s3_bucket" "finance" {
  bucket = "terraform-d99-finance"
  tags = {
    Description = "Bucket for finance"
  }
}

resource "aws_s3_object" "finance-2023" {
  bucket = aws_s3_bucket.finance.id
  key    = "finance-2023.json"
  content = "./finance.json"
}

data "aws_iam_group" "finance-data" {
  group_name = "finance-analysts"
}

data "aws_iam_user" "terry" {
  user_name = "terry"
}

resource "aws_s3_bucket_policy" "finance_policy" {
  bucket = aws_s3_bucket.finance.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "*"
        "Effect" : "Allow"
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.finance.id}/*"
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${var.aws_account_id}:user/${data.aws_iam_user.terry.user_name}"
          ]
        }
      }
    ]
  })
}

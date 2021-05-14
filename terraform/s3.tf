provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "b" {
  bucket = "proshop-static"
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "AllowPublicRead",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "*"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.b.arn}/*"
      }
    ]
  })
}

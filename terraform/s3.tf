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

# create policy to give EC2 worker nodes access
# https://django-storages.readthedocs.io/en/latest/backends/amazon-S3.html#iam-policy
data "aws_iam_policy_document" "s3_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      aws_s3_bucket.b.arn,
      "${aws_s3_bucket.b.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_policy" {
  name        = "EC2AccessS3"
  description = "Give limited S3 permissions, put, get, list, delete"
  policy      = data.aws_iam_policy_document.s3_policy_document.json
  tags = {
    managed-by = "terraform"
  }
}

output "aws_policy_arn" {
  value = aws_iam_policy.s3_policy.arn
}

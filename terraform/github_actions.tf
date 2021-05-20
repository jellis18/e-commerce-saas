# Create IAM user for Github Actions with minimum required permissions
resource "aws_iam_user" "github_actions" {
  name = "github-actions"
  tags = {
    managed-by = "terraform"
  }
}

# Create key
resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name
  depends_on = [
    aws_iam_user.github_actions
  ]
}

# Create user policy document
# Follow minimum policy from https://github.com/aws-actions/amazon-ecr-login
data "aws_iam_policy_document" "policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload"
    ]
    resources = [
      aws_ecr_repository.api.arn,
      aws_ecr_repository.ui.arn
    ]
  }
}

# Create policy
resource "aws_iam_user_policy" "policy" {
  name   = "github-actions-policy"
  user   = aws_iam_user.github_actions.name
  policy = data.aws_iam_policy_document.policy_document.json
}

# key for github actions
data "github_actions_public_key" "key" {
  repository = "e-commerce-saas"
}

# set aws access key in github actions
resource "github_actions_secret" "access_key" {
  repository      = "e-commerce-saas"
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = aws_iam_access_key.github_actions.id
}

# set aws secret access key in github actions
resource "github_actions_secret" "secret_key" {
  repository      = "e-commerce-saas"
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = aws_iam_access_key.github_actions.secret
}

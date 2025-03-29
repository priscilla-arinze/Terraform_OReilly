provider "aws" {
  region = "us-east-1"
}

## Using count
# resource "aws_iam_user" "example" {
#   count = 3  # creates 3 copies of the resource
#   name  = "priscilla-${count.index}"
# }

# resource "aws_iam_user" "example" {
#   count = length(var.user_names)  # creates 3 copies of the resource
#   name  = var.user_names[count.index]
# }

# module "users" {
#   source = "../../modules/landing-zone/iam-user"

#   count     = length(var.user_names)
#   user_name = var.user_names[count.index]
  
# }

## Using for_each
# resource "aws_iam_user" "example" {
#   for_each = toset(var.user_names)
#   name     = each.value
# }


resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}


module "users" {
  source = "../../modules/landing-zone/iam-user"

  for_each  = toset(var.user_names)
  user_name = each.value
  
  give_priscilla_cloudwatch_full_access = true
  cloudwatch_read_only_arn              = aws_iam_policy.cloudwatch_read_only.arn
  cloudwatch_full_access_arn            = aws_iam_policy.cloudwatch_full_access.arn
}
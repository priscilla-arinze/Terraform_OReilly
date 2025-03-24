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

module "users" {
  source = "../../modules/landing-zone/iam-user"

  for_each  = toset(var.user_names)
  user_name = each.value
  
}
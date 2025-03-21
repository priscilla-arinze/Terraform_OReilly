provider "aws" {
  region = "us-east-1"
}

# resource "aws_iam_user" "example" {
#   count = 3  # creates 3 copies of the resource
#   name  = "priscilla-${count.index}"
# }

resource "aws_iam_user" "example" {
  count = length(var.user_names)  # creates 3 copies of the resource
  name  = var.user_names[count.index]
}
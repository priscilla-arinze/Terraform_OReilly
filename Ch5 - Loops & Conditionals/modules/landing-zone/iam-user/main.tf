resource "aws_iam_user" "example" {
  count = 1
  name  = var.user_name
}


resource "aws_iam_user_policy_attachment" "priscilla_cloudwatch_full_access" {
  count      = (
    var.give_priscilla_cloudwatch_full_access && var.user_name == "priscilla" 
    ? 1 
    : 0
  ) # (IF) Create resource if given cloudwatch full access
  user       = aws_iam_user.example[0].name
  policy_arn = var.cloudwatch_full_access_arn
}

resource "aws_iam_user_policy_attachment" "priscilla_cloudwatch_read_only" {
  count      = (
    var.give_priscilla_cloudwatch_full_access && var.user_name == "priscilla" 
    ? 0 
    : 1
  ) # (ELSE) Do NOT create resource if given cloudwatch full access
  user       = aws_iam_user.example[0].name
  policy_arn = var.cloudwatch_read_only_arn
}

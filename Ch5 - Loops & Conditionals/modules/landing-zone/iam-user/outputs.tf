output "user_arn" {
  value       = aws_iam_user.example[0].arn
  description = "The ARN for the user"
}

# output "priscilla_cloudwatch_policy_arn" {
#   value = (
#     var.give_priscilla_cloudwatch_full_access
#     ? aws_iam_user_policy_attachment.priscilla_cloudwatch_full_access[0].policy_arn
#     : aws_iam_user_policy_attachment.priscilla_cloudwatch_read_only[0].policy_arn
#   )
# }

# More robust way to get the policy ARN compared to the one above
output "priscilla_cloudwatch_policy_arn" {
  description = "The ARN for the CloudWatch policy attached to Priscilla"
  value = one(concat(
    aws_iam_user_policy_attachment.priscilla_cloudwatch_full_access[*].policy_arn,
    aws_iam_user_policy_attachment.priscilla_cloudwatch_read_only[*].policy_arn
  ))
}
# output "first_iam_user_arn" {
#     value       = module.users[0].user_arn
#     description = "The ARN for the first user"
# }

# output "all_arns" {
#     value       = values(aws_iam_user.example)[*].arn
#     description = "The ARNs for all users"
# }

# output "all_users" {
#   value = aws_iam_user.example
# }

output "user_arns" {
    value = values(module.users)[*].user_arn
}
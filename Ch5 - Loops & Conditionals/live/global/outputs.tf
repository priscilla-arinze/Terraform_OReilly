# output "first_iam_user_arn" {
#     value       = module.users[0].user_arn
#     description = "The ARN for the first user"
# }

# output "all_arns" {
#     value       = module.users[*].user_arn
#     description = "The ARNs for all users"
# }

output "all_users" {
  value = aws_iam_user.example
}
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

output "upper_names" {
    value = [for name in var.user_names : upper(name)]
}

output "short_upper_names" {
    value = [for name in var.user_names : upper(name) if length(name) < 5]
}

output "occupations" {
    value = [for name, occupation in var.user_occupations : "${name} is a ${occupation}"]
}

output "upper_occupations" {
    value = {for name, occupation in var.user_occupations : upper(name) => upper(occupation)}
    # Returns { "PRISCILLA" = "ENGINEER", "MARK" = "MANAGER", "LISA" = "DESIGNER" }
}

output "string_for_directive_names" {
    value = "%{ for name in var.user_names }${name}, %{ endfor }"
    # Returns "priscilla, mark, lisa, "
}

output "string_for_directive_index_names" {
    value = "%{ for i, name in var.user_names }(${i+1}) ${name}, %{ endfor }"
    # Returns "(1) priscilla, (2) mark, (3) lisa, "
}
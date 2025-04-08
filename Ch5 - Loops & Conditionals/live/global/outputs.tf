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

output "string_for_directive_index_names_with_condition" {
    # Note: For HEREDOC, make sure to omit the leading whitespace before the for directive
    value = <<EOF
%{ for i, name in var.user_names }
${name}%{ if i < length(var.user_names) - 1 }, %{ endif }
%{ endfor }
EOF
    # Returns "priscilla, 

             # mark, 

             # lisa"
}

output "string_for_directive_index_names_with_condition_stripped" {
    # This is the same as the previous output, but with the leading and trailing whitespace removed using ~
    # Note: To strip the whitespace, make sure to omit any whitspace between ~ and curly braces
    value = <<EOF
%{~ for i, name in var.user_names ~}
${name}%{ if i < length(var.user_names) - 1 }, %{ endif }
%{~ endfor ~}
EOF
    # Returns "priscilla, mark, lisa"
}

output "string_for_directive_index_names_with_if_else_stripped" {
    value = <<EOF
%{~ for i, name in var.user_names ~}
${name}%{ if i < length(var.user_names) - 1 }, %{ else }. %{ endif }
%{~ endfor ~}
EOF
    # Returns "priscilla, mark, lisa."
}
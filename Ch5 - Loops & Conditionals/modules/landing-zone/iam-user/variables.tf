variable "user_name" {
  description = "Create an IAM user with this name"
  type        = string
}

variable "cloudwatch_read_only_arn" {
  type = string
}

variable "cloudwatch_full_access_arn" {
  type = string
}

variable "give_priscilla_cloudwatch_full_access" {
  description = "If true, give Priscilla CloudWatch full access"
  type        = bool
}
variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["priscilla", "mark", "lisa"]
}

variable "user_occupations" {
  description = "Map of the occupations of the users"
  type        = map(string)
  default     = {
    priscilla = "engineer"
    mark      = "manager"
    lisa      = "designer"
  }
}
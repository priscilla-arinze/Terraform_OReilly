variable "database_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "database_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}
variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "priscilla-terraform-up-and-running-state"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table to use for state locking"
  type        = string
  default     = "terraform-up-and-running-locks"
}
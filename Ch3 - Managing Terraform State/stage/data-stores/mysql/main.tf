provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "priscilla-terraform-up-and-running-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10 # 10 GB
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "example_database"

  # Will be set as environment variables (TF_VAR_db_username, TF_VAR_db_password)
  username = var.db_username
  password = var.db_password
}
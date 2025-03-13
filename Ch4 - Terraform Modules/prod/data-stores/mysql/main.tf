provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "priscilla-terraform-up-and-running-state"
    key    = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  db_env      = "prod"
  db_username = var.database_username
  db_password = var.database_password
}
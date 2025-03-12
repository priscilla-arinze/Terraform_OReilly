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

module "mysql" {
  source = "../../../modules/data-stores/mysql"

  db_env      = "stage"
  db_username = var.database_username # not sure if this will work
  db_password = var.database_password
}
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
  source = "git::https://github.com/priscilla-arinze/Terraform_OReilly_Modules.git//data-stores/mysql?ref=v0.0.1-stage"

  db_env      = "stage"
  db_username = var.database_username
  db_password = var.database_password
}
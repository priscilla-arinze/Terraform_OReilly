provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "priscilla-terraform-up-and-running-state"
    key    = "prod/services/ch2-webserver-cluster/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "webserver_cluster" {
    source = "../../../modules/services/ch2-webserver-cluster"

    cluster_name = "webservers-prod"
    db_remote_state_bucket = "priscilla-terraform-up-and-running-state"
    db_remote_state_key = "prod/data-stores/mysql/terraform.tfstate"
}
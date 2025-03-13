provider "aws" {
    region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "priscilla-terraform-up-and-running-state"
    key    = "stage/services/ch2-webserver-cluster/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "webserver_cluster" {
    source = "../../../modules/services/ch2-webserver-cluster"

    cluster_name           = "webservers-stage"
    db_remote_state_bucket = "priscilla-terraform-up-and-running-state"
    db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
    instance_type          = "t2.micro"
    min_size               = 2
    max_size               = 2
}
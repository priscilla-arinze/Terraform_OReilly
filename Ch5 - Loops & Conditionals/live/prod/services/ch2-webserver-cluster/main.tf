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


### Modules
module "webserver_cluster" {
    source = "../../../../modules/services/ch2-webserver-cluster"

    ami         = "ami-04b4f1a9cf54c11d0"
    server_text = "New server text - prod"

    cluster_name = "webservers-prod"
    db_remote_state_bucket = "priscilla-terraform-up-and-running-state"
    db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"

    instance_type = "t2.micro" # can opt for a larger instance (m4.large [not on free tier]) for production
    min_size      = 2
    max_size      = 10

    custom_tags = {
      Owner       = "team-priscilla"
      ManagedBy   = "Terraform"
      Environment = "Production"
    }

    enable_autoscaling = true
}
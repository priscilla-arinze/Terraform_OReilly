provider "aws" {
    region = "us-east-1"
}

module "webserver_cluster" {
    source = "../../../modules/services/ch2-webserver-cluster"

    cluster_name           = "webservers-stage"
    db_remote_state_bucket = "priscilla-terraform-up-and-running-state"
    db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
}
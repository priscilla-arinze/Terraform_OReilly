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
    source = "git::https://github.com/priscilla-arinze/Terraform_OReilly_Modules.git//services/ch2-webserver-cluster?ref=v0.0.1-stage"

    cluster_name           = "webservers-stage"
    db_remote_state_bucket = "priscilla-terraform-up-and-running-state"
    db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
    instance_type          = "t2.micro"
    min_size               = 2
    max_size               = 2
}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port = 12345
  to_port = 12345
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
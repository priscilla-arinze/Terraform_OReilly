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
    source = "git::https://github.com/priscilla-arinze/Terraform_OReilly_Modules.git//services/ch2-webserver-cluster?ref=v0.0.1-prod"

    cluster_name = "webservers-prod"
    db_remote_state_bucket = "priscilla-terraform-up-and-running-state"
    db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
    instance_type          = "t2.micro" # can opt for a larger instance (m4.large [not on free tier]) for production
    min_size               = 2
    max_size               = 10
}


### Resources
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *" # 9am UTC every day

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *" # 5pm UTC every day

  autoscaling_group_name = module.webserver_cluster.asg_name
}
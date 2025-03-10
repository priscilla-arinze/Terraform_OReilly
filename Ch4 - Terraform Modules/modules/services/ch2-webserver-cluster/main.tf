terraform {
  backend "s3" {
    bucket = "priscilla-terraform-up-and-running-state"
    key    = "stage/services/ch2-webserver-cluster/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

### Resources
# Can't use this in conjunction with the autoscaling group; need to use launch template instead (as of October 2024)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template
# resource "aws_launch_configuration" "example" {
#   image_id        = "ami-04b4f1a9cf54c11d0"
#   instance_type   = "t2.micro"
#   security_groups = [aws_security_group.instance.id]

#   user_data = <<-EOF
#                 #!/bin/bash
#                 echo "Hello, World" > index.html
#                 nohup busybox httpd -f -p ${var.server_port} &
#                 EOF
#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_launch_template" "example" {
  image_id        = "ami-04b4f1a9cf54c11d0"
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(
    templatefile(
      "user-data.sh",
      {
        server_port = var.server_port
        db_address  = data.terraform_remote_state.db.outputs.address
        db_port     = data.terraform_remote_state.db.outputs.port
      }
    )
  )

  # Required when using a launch configuration with an auto scaling group
  lifecycle {
    create_before_destroy = true
  }
}

# Using launch template instead of aws_instance for autoscaling group
# resource "aws_instance" "example" {
#   ami                    = "ami-04b4f1a9cf54c11d0"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.instance.id]

#   user_data = <<-EOF
#                 #!/bin/bash
#                 echo "Hello, World" > index.html
#                 nohup busybox httpd -f -p ${var.server_port} &
#                 EOF

#   user_data_replace_on_change = true

#   tags = {
#     Name = "terraform-example"
#   }
# }

resource "aws_autoscaling_group" "example" {
  launch_template {
    id = aws_launch_template.example.id
  }

  vpc_zone_identifier  = data.aws_subnets.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "example" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = 200
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  # Allow all inbound traffic on the HTTP port
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic on HTTP port
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Data Sources
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "priscilla-terraform-up-and-running-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-1"
  }
}
resource "aws_db_instance" "example" {
  identifier_prefix   = "${var.db_env}-terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10 # 10 GB
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "${var.db_env}terraformmysqldb"

  # Will be set as environment variables (TF_VAR_db_username, TF_VAR_db_password)
  username = var.db_username
  password = var.db_password
}
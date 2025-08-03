resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-rds-subnet-group"
  subnet_ids = var.db_subnet_ids
  description = "Subnet group for RDS"

  tags = {
    Name = "${var.name_prefix}-rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier              = var.db_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.this.name
  publicly_accessible     = var.publicly_accessible
  multi_az                = false
  storage_type            = "gp2"
  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name = "${var.name_prefix}-RDS"
  }
}

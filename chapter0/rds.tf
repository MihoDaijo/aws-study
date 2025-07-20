resource "aws_db_instance" "mysql" {
  identifier              = "aws-study-rds2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_password
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnets.name
  publicly_accessible     = false
  multi_az                = false
  storage_type            = "gp2"
  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name = "${var.name_prefix}-RDS"
  }
}

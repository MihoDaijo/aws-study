resource "aws_db_subnet_group" "rds_subnets" {
  name       = "${var.name_prefix}-rds-subnet-group"
  description = "DB Subnet Group"
  subnet_ids = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "${var.name_prefix}-RDS-SubnetGroup"
  }
}

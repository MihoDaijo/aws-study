resource "aws_subnet" "public_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-PublicSubnet1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-PublicSubnet2"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name_prefix}-PrivateSubnet1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.name_prefix}-PrivateSubnet2"
  }
}

data "aws_availability_zones" "available" {}

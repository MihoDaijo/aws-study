terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "tf-handson-mihodaijo"
    key    = "terraform/state.tfstate"
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# VPC
module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "${var.name_prefix}-VPC"
}

# Subnet
module "subnet" {
  source      = "./modules/subnet"
  vpc_id      = module.vpc.vpc_id
  name_prefix = var.name_prefix
  azs         = data.aws_availability_zones.available.names
}

# Internet Gateway
module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
  name   = "${var.name_prefix}-IGW"
}

# Route
module "route" {
  source            = "./modules/route"
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.igw.igw_id
  public_subnet_ids = module.subnet.public_subnet_ids
  name_prefix       = var.name_prefix
}

# Security Groups
module "security_group" {
  source      = "./modules/security_group"
  vpc_id      = module.vpc.vpc_id
  my_home_ip  = var.my_home_ip
  name_prefix = var.name_prefix
}

# EC2
module "ec2" {
  source             = "./modules/ec2"
  ami                = data.aws_ami.al2023.id
  instance_type      = var.instance_type
  subnet_id          = module.subnet.public_subnet_ids[0]
  security_group_ids = [module.security_group.ec2_sg_id]
  key_name           = var.key_name
  name               = "${var.name_prefix}-EC2"

  user_data = <<-EOF
#!/bin/bash
set -euxo pipefail

dnf -y update
dnf -y install ansible

cat > /home/ec2-user/java.yml <<'YAML'
- hosts: localhost
  connection: local
  become: true
  tasks:
    - name: Install Java (Amazon Corretto 21)
      ansible.builtin.dnf:
        name: java-21-amazon-corretto-devel
        state: present

    - name: Verify java
      ansible.builtin.command: java -version
      register: jver
      changed_when: false

    - debug:
        var: jver.stderr_lines
YAML

chown ec2-user:ec2-user /home/ec2-user/java.yml

# ★追加：inventory.ini を作成
cat > /home/ec2-user/inventory.ini <<'INV'
[local]
localhost ansible_connection=local
INV
chown ec2-user:ec2-user /home/ec2-user/inventory.ini

# ★変更：inventory を指定して実行
ansible-playbook -i /home/ec2-user/inventory.ini /home/ec2-user/java.yml
EOF
}

# RDS
module "rds" {
  source                 = "./modules/rds"
  db_identifier          = "aws-study-rds2"
  db_name                = "awsstudy"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_username            = var.db_username
  db_password            = var.db_password
  publicly_accessible    = false
  vpc_security_group_ids = [module.security_group.rds_sg_id]
  db_subnet_ids          = module.subnet.private_subnet_ids
  name_prefix            = var.name_prefix
}

# ALB
module "alb" {
  source            = "./modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.subnet.public_subnet_ids
  alb_sg_id         = module.security_group.alb_sg_id
  name_prefix       = var.name_prefix
  instance_id       = module.ec2.instance_id
}

# WAF
module "waf" {
  source       = "./modules/waf"
  name         = "${var.name_prefix}-WAF"
  resource_arn = module.alb.alb_arn
}

# CloudWatch
module "cloudwatch" {
  source             = "./modules/cloudwatch"
  ec2_instance_id    = module.ec2.instance_id
  name_prefix        = var.name_prefix
  notification_email = var.notification_email # ← 追加！
  cpu_threshold      = 0.03                   # ←ここで0.03にする
}

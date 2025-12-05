data "aws_ssm_parameter" "al2023_ami" {
  # x86_64 の AL2023 最新AMI
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  associate_public_ip_address = true
  disable_api_termination     = true

  user_data = var.user_data

  tags = {
    Name = var.name
  }
}

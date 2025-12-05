data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  # Amazon Linux 2023 x86_64 AMI（名前で絞る）
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  # 仮想化方式
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # EBSルート（念のため）
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  # 利用可能なAMIのみ（念のため）
  filter {
    name   = "state"
    values = ["available"]
  }
}

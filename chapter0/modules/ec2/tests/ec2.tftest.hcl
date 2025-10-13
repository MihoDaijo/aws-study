provider "aws" {
  region = "ap-northeast-1"
}

# ✅ 正常系
run "plan_ok" {
  command = plan
  module { source = "./" }

  variables {
    name               = "aws-study-tf-ec2"
    ami                = "ami-060c08771176b34b4"
    instance_type      = "t3.micro"
    subnet_id          = "subnet-1234567890abcdef0"
    security_group_ids = ["sg-1234567890abcdef0"]
    key_name           = "daijomiho"
  }

  assert {
    condition     = output.instance_type == "t3.micro"
    error_message = "instance_type must be t3.micro"
  }

  assert {
    condition     = output.ami == "ami-060c08771176b34b4"
    error_message = "AMI must be ami-060c08771176b34b4"
  }

  assert {
    condition     = output.subnet_id != null && length(output.subnet_id) > 0
    error_message = "subnet_id must be set"
  }

  assert {
    condition     = length(output.security_group_ids) >= 1
    error_message = "At least one security group must be attached"
  }

  assert {
    condition     = output.key_name == "daijomiho"
    error_message = "key_name must be daijomiho"
  }

  assert {
    condition     = output.name_tag == "aws-study-tf-ec2"
    error_message = "Name tag mismatch"
  }
}

# ❌ 異常系（variables.tf に validation を入れてある前提）

run "invalid_ami_fails" {
  command = plan
  module { source = "./" }

  variables {
    name               = "aws-study-tf-ec2"
    ami                = "ami-XYZ"                 # 不正形式
    instance_type      = "t3.micro"
    subnet_id          = "subnet-12345678"
    security_group_ids = ["sg-12345678"]
    key_name           = "daijomiho"
  }

  expect_failures = [var.ami]
}

run "invalid_instance_type_fails" {
  command = plan
  module { source = "./" }

  variables {
    name               = "aws-study-tf-ec2"
    ami                = "ami-060c08771176b34b4"
    instance_type      = "INVALID.TYPE!"           # 不正形式
    subnet_id          = "subnet-12345678"
    security_group_ids = ["sg-12345678"]
    key_name           = "daijomiho"
  }

  expect_failures = [var.instance_type]
}

run "invalid_subnet_fails" {
  command = plan
  module { source = "./" }

  variables {
    name               = "aws-study-tf-ec2"
    ami                = "ami-060c08771176b34b4"
    instance_type      = "t3.micro"
    subnet_id          = "sub-xxxx"                # 不正形式
    security_group_ids = ["sg-12345678"]
    key_name           = "daijomiho"
  }

  expect_failures = [var.subnet_id]
}

run "empty_sg_list_fails" {
  command = plan
  module { source = "./" }

  variables {
    name               = "aws-study-tf-ec2"
    ami                = "ami-060c08771176b34b4"
    instance_type      = "t3.micro"
    subnet_id          = "subnet-12345678"
    security_group_ids = []                        # 空
    key_name           = "daijomiho"
  }

  expect_failures = [var.security_group_ids]
}

run "empty_key_name_fails" {
  command = plan
  module { source = "./" }

  variables {
    name               = "aws-study-tf-ec2"
    ami                = "ami-060c08771176b34b4"
    instance_type      = "t3.micro"
    subnet_id          = "subnet-12345678"
    security_group_ids = ["sg-12345678"]
    key_name           = ""                        # 空
  }

  expect_failures = [var.key_name]
}

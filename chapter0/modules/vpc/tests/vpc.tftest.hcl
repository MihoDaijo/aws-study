provider "aws" {
  region = "ap-northeast-1"
}

# ✅ 正常系
run "plan_ok" {
  command = plan
  module {
    source = "./"
  }

  variables {
    cidr_block = "10.0.0.0/16"
    name       = "aws-study-tf-vpc"
  }

  assert {
    condition     = output.vpc_cidr == "10.0.0.0/16"
    error_message = "vpc_cidr must be 10.0.0.0/16"
  }

  assert {
    condition     = output.dns_support_enabled == true
    error_message = "enable_dns_support must be true"
  }

  assert {
    condition     = output.dns_hostnames_enabled == true
    error_message = "enable_dns_hostnames must be true"
  }
}

# ❌ 意図的に失敗させるテスト（VPCの出力に対して不一致を主張）
run "intentional_fail_demo" {
  command = plan
  module { source = "./" }

  variables {
    cidr_block = "10.0.0.0/16"
    name       = "aws-study-tf-vpc"
  }

  assert {
    condition     = output.vpc_cidr == "192.168.0.0/16" # わざと間違い
    error_message = "Intentional fail: expected 192.168.0.0/16"
  }
}

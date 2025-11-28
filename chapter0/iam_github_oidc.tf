########################################
# IAM for GitHub Actions (PLAN / APPLY)
# - PLAN: devブランチ＆PRで plan/test のみ（読み取り権限）
# - APPLY: main でのみ apply 可能（承認必須ワークフローと併用）
########################################

locals {
  github_repo = "MihoDaijo/aws-study"

  # OIDC Subject（どの実行を許可するか）
  # main での push 実行のみ（APPLY用）
  sub_main = "repo:${local.github_repo}:ref:refs/heads/main"
  # 開発ブランチや PR 実行（PLAN用）。PRは refs/pull/*/merge で来る
  sub_heads = "repo:${local.github_repo}:ref:refs/heads/*"
  sub_pr    = "repo:${local.github_repo}:pull_request"

  # Terraform backend
  bucket_name = "tf-handson-mihodaijo"
  region      = "ap-northeast-1"
  ddb_table   = "terraform-lock" # DynamoDB ロックテーブル名（別途作成して使う）
}

########################################
# GitHub OIDC Provider
# 既に手動作成済みなら "terraform import" で取り込み可
########################################
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # GitHub OIDC のルートCAフィンガープリント（ATS）
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
  lifecycle {
    prevent_destroy = true
  }
}

########################################
# TRUST POLICIES
########################################
# APPLY（main のみ）
data "aws_iam_policy_document" "trust_apply_main" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # main ブランチのみ
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.sub_main]
    }
  }
}

# PLAN（開発ブランチ & PR）
data "aws_iam_policy_document" "trust_plan_all" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # devブランチ(push等) + PR(plan) を許可
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [local.sub_heads, local.sub_pr]
    }
  }
}

########################################
# ROLES
########################################
resource "aws_iam_role" "gha_tf_apply" {
  name                 = "github-actions-terraform-apply"
  assume_role_policy   = data.aws_iam_policy_document.trust_apply_main.json
  description          = "Apply role (main only)"
  max_session_duration = 3600
}

resource "aws_iam_role" "gha_tf_plan" {
  name                 = "github-actions-terraform-plan"
  assume_role_policy   = data.aws_iam_policy_document.trust_plan_all.json
  description          = "Plan-only role (dev branches & PR)"
  max_session_duration = 3600
}

########################################
# POLICIES (Documents)
########################################
# 共通：State backend 読み取り＋DynamoDB ロック操作
data "aws_iam_policy_document" "common_state_access" {
  statement {
    sid    = "S3StateAccess"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }

  statement {
    sid    = "DynamoDBLock"
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:${local.region}:*:table/${local.ddb_table}"
    ]
  }
}

# PLAN用：読み取り系のみ（Describe/List/Get）
data "aws_iam_policy_document" "plan_readonly_services" {
  statement {
    sid    = "ReadOnlyServices"
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "elasticloadbalancing:Describe*",
      "rds:Describe*",
      "cloudwatch:Describe*",
      "logs:Describe*",
      "sns:List*",
      "sns:Get*",
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
      "autoscaling:Describe*",
      "iam:Get*",
      "iam:List*"
    ]
    resources = ["*"]
  }
}

# APPLY用：作成/更新/削除を許可（まずは広め→後で最小権限に絞る）
data "aws_iam_policy_document" "apply_services" {
  statement {
    sid    = "TerraformApplyWrites"
    effect = "Allow"
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "rds:*",
      "cloudwatch:*",
      "logs:*",
      "sns:*",
      "ssm:*",
      "autoscaling:*",

      # ★ 追加: WAF を Terraform から作成/更新/削除できるように
      "wafv2:*",

      # ★ 追加: GitHub Actions 用の IAM 操作用
      "iam:CreateOpenIDConnectProvider",
      "iam:CreatePolicy",
      "iam:AttachRolePolicy",
      "iam:UpdateAssumeRolePolicy"
    ]
    resources = ["*"]
  }

  # apply 時は state 更新が発生するため S3 Put/Delete が必要
  statement {
    sid    = "S3PutDeleteState"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }
}

# どちらのロールでも IAM/Organizations/Account 管理系は拒否
data "aws_iam_policy_document" "deny_iam_admin" {
  statement {
    sid    = "DenyIAMAdmin"
    effect = "Deny"
    actions = [
      # "iam:*",  # ★ コメントアウト or 削除
      "organizations:*",
      "account:*"
    ]
    resources = ["*"]
  }
}

########################################
# POLICIES (Resources)
########################################
resource "aws_iam_policy" "common_state_access" {
  name        = "tf-common-state-access"
  description = "Terraform state S3 (get/list) & DynamoDB lock access"
  policy      = data.aws_iam_policy_document.common_state_access.json
}

resource "aws_iam_policy" "plan_readonly" {
  name        = "tf-plan-readonly-services"
  description = "Read-only permissions for plan/test on dev branches & PR"
  policy      = data.aws_iam_policy_document.plan_readonly_services.json
}

resource "aws_iam_policy" "apply_writable" {
  name        = "tf-apply-writable-services"
  description = "Writable permissions for apply on main"
  policy      = data.aws_iam_policy_document.apply_services.json
}

resource "aws_iam_policy" "deny_admin" {
  name        = "tf-deny-iam-admin"
  description = "Deny admin-level IAM/Organizations/Account operations"
  policy      = data.aws_iam_policy_document.deny_iam_admin.json
}

########################################
# ATTACHMENTS
########################################
# PLAN role
resource "aws_iam_role_policy_attachment" "plan_common" {
  role       = aws_iam_role.gha_tf_plan.name
  policy_arn = aws_iam_policy.common_state_access.arn
}

resource "aws_iam_role_policy_attachment" "plan_read" {
  role       = aws_iam_role.gha_tf_plan.name
  policy_arn = aws_iam_policy.plan_readonly.arn
}

/* Plan には Deny を付けない（Describe/Get/List まで潰れるため）
resource "aws_iam_role_policy_attachment" "plan_deny" {
  role       = aws_iam_role.gha_tf_plan.name
  policy_arn = aws_iam_policy.deny_admin.arn
}
*/

# APPLY role
resource "aws_iam_role_policy_attachment" "apply_common" {
  role       = aws_iam_role.gha_tf_apply.name
  policy_arn = aws_iam_policy.common_state_access.arn
}

resource "aws_iam_role_policy_attachment" "apply_write" {
  role       = aws_iam_role.gha_tf_apply.name
  policy_arn = aws_iam_policy.apply_writable.arn
}

resource "aws_iam_role_policy_attachment" "apply_deny" {
  role       = aws_iam_role.gha_tf_apply.name
  policy_arn = aws_iam_policy.deny_admin.arn
}

########################################
# OUTPUTS
########################################
output "role_arn_plan" {
  description = "GitHub Actions PLAN role ARN (dev branches & PR)"
  value       = aws_iam_role.gha_tf_plan.arn
}

output "role_arn_apply" {
  description = "GitHub Actions APPLY role ARN (main only)"
  value       = aws_iam_role.gha_tf_apply.arn
}

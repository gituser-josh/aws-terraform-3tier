# === Data source: AWS アカウント情報を取得 ===
# 用途：S3 パケット名にアカウント ID を埋めて、グローバル一意を保証
data "aws_caller_identity" "current" {}

# === S3 パケット：Terraform ステート保存先 ===

resource "aws_s3_bucket" "tfstate" {
  # S3 パケット名はグローバル一位(全 AWS で重複不可)  
  # → アカウント ID + リージョンで衝突回避
  bucket = "tfstate-${data.aws_caller_identity.current.account_id}-ap-northeast-1"

  # 学習用なので削除を許可(本番では prevent_destroy = true)
  lifecycle {
    prevent_destroy = false
  }
}

# === S3 セキュリティ 3 点セット ===

# 1. パブリックアクセスを完全ブロック
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#2. バージョニング有効化(ステート履歴を保持)
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

#3. サーバーサイド暗号化(ステートには機密情報を含む)
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# === DynamoDB テーブル：ステートロック用 ===

resource "aws_dynamodb_table" "tflock" {
  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S" #string
  }
}

# === Outputs: Step 3 の backend.tf で参照する値 ===

output "tfstate_bucket_name" {
  description = "S3 bucket name form Terraform state"
  value       = aws_s3_bucket.tfstate.id
}

output "tflock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  value       = aws_dynamodb_table.tflock.name
}

output "tfstate_region" {
  description = "AWS region of the backend"
  value       = "ap-northeast-1"
}
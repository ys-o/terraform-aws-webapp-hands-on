#ランダム文字列（S3バケット名に使う為）
resource "random_string" "s3_unique_key" {
  length  = 6
  upper   = false
  lower   = true
  number  = true
  special = false
}

#S3バケット（静的コンテンツ格納用）
resource "aws_s3_bucket" "s3_static_bucket" {
  bucket        = "${var.project}-${var.environment}-static-bucket-${random_string.s3_unique_key.result}"
  force_destroy = true

  versioning {
    enabled = false
  }
}

#パブリックアクセス制御（静的コンテンツ格納用）
resource "aws_s3_bucket_public_access_block" "s3_static_bucket" {
  bucket                  = aws_s3_bucket.s3_static_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

#バケットポリシーの紐づけ（静的コンテンツ格納用）
resource "aws_s3_bucket_policy" "s3_static_bucket" {
  bucket = aws_s3_bucket.s3_static_bucket.id
  policy = data.aws_iam_policy_document.s3_static_bucket.json

  depends_on = [
    aws_s3_bucket_public_access_block.s3_static_bucket
  ]
}

#バケットポリシー定義（静的コンテンツ格納用）
data "aws_iam_policy_document" "s3_static_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_static_bucket.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


#ローカルの資材を指定し、アップロード（静的コンテンツ格納用）
locals {
  static_content_dir = "${path.module}/XXXXXX/2203-一般公開バケット作成/静的コンテンツ/public"
}


resource "aws_s3_bucket_object" "s3_static_bucket_files" {

  for_each = fileset(local.static_content_dir, "**")

  bucket = aws_s3_bucket.s3_static_bucket.id
  key    = "public/${each.value}"
  source = "${local.static_content_dir}/${each.value}"

  etag = filemd5("${local.static_content_dir}/${each.value}")
}




#S3バケット（EC2オートスケーリング時の資材提供用）
resource "aws_s3_bucket" "s3_deploy_bucket" {
  bucket        = "${var.project}-${var.environment}-deploy-bucket-${random_string.s3_unique_key.result}"
  force_destroy = true

  versioning {
    enabled = false
  }
}

#パブリックアクセス制御（EC2オートスケーリング時の資材提供用）
resource "aws_s3_bucket_public_access_block" "s3_deploy_bucket" {
  bucket                  = aws_s3_bucket.s3_deploy_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#バケットポリシーの紐づけ（EC2オートスケーリング時の資材提供用）
resource "aws_s3_bucket_policy" "s3_deploy_bucket" {
  bucket = aws_s3_bucket.s3_deploy_bucket.id
  policy = data.aws_iam_policy_document.s3_deploy_bucket.json
  depends_on = [
    aws_s3_bucket_public_access_block.s3_deploy_bucket
  ]
}

#バケットポリシー定義（EC2オートスケーリング時の資材提供用）
data "aws_iam_policy_document" "s3_deploy_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_deploy_bucket.arn}/*"]
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.ap_iam_role.arn
      ]
    }
  }
}

#ローカルの資材を指定し、アップロード（EC2オートスケーリング時の資材提供用）
resource "aws_s3_bucket_object" "s3_deploy_bucket_files" {

  for_each = fileset(path.module, "XXXXXX/2204-プライベートバケット作成/デプロイ用コンテンツ/*")

  bucket = aws_s3_bucket.s3_deploy_bucket.id
  key    = split("/", each.value)[3]
  source = each.value

  etag = filemd5(each.value)
}


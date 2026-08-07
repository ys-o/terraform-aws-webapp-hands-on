# tfstate格納用S3作成
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}

data "aws_iam_user" "terraform" {
  user_name = "terraform"
}

resource "random_string" "bucket_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "tastylog-dev-tfstate-bucket-${random_string.bucket_suffix.result}"
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = data.aws_iam_user.terraform.arn
        }

        Action = "s3:*"

        Resource = [
          aws_s3_bucket.tfstate.arn,
          "${aws_s3_bucket.tfstate.arn}/*"
        ]
      }
    ]
  })
}
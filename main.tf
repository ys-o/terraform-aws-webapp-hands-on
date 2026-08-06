# terraformブロック、バージョン等の指定
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

# providerブロック、利用するprofile(認証情報)とリージョンの指定
provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}

# variableブロック、各変数の宣言（詳細な定義は別ファイルterraform.tfvars）
variable "project" {
  type = string
}

variable "environment" {
  type = string
}
# dataブロック、s3のプレフィクスリスト
data "aws_prefix_list" "s3_prefix_list" {
  name = "com.amazonaws.us-east-1.s3"
}
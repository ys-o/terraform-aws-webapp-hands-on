# dataブロック、s3のプレフィクスリスト
data "aws_prefix_list" "s3_prefix_list" {
  name = "com.amazonaws.us-east-1.s3"
}

# 鍵
data "aws_key_pair" "mykey" {
  key_name = "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
}

# 
data "aws_ami" "app" {
  most_recent = true
  owners      = ["self", "amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.12-x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
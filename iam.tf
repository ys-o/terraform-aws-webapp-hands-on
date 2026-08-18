#信頼ポリシー
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#ap用iamロール
resource "aws_iam_role" "ap_iam_role" {
  name               = "${var.project}-${var.environment}-ap-iam-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

#ポリシー４つアタッチ
resource "aws_iam_role_policy_attachment" "ap_iam_role_ec2_readonly" {
  role       = aws_iam_role.ap_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ap_iam_role_ssm_managed" {
  role       = aws_iam_role.ap_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ap_iam_role_ssm_readonly" {
  role       = aws_iam_role.ap_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "ap_iam_role_s3_readonly" {
  role       = aws_iam_role.ap_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

#インスタンスプロフィール
resource "aws_iam_instance_profile" "ap_ec2_profile" {
  name = aws_iam_role.ap_iam_role.name
  role = aws_iam_role.ap_iam_role.name
}
# 踏み台サーバー
resource "aws_instance" "tastylog_step_server" {
  ami           = data.aws_ami.app.id
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.operation_sg.id,
    aws_security_group.ap_sg.id
  ]

  key_name = data.aws_key_pair.mykey.key_name

  user_data = <<EOF
#!/bin/bash
dnf install -y mariadb105
EOF

  tags = {
    Name    = "${var.project}-${var.environment}-step-server"
    Project = var.project
    Env     = var.environment
  }
}
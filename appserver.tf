resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_instance" "ap_server" {
  ami                         = "ami-0db37c0cb4c25ccf3"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ap_ec2_profile.name

  vpc_security_group_ids = [
    aws_security_group.ap_sg.id,
    aws_security_group.operation_sg.id
  ]

  key_name = aws_key_pair.keypair.key_name

  user_data = <<-EOF
    #!/bin/bash
    cd /home/ec2-user/middleware
    sh install.sh
    systemctl restart tastylog
  EOF

  tags = {
    Name    = "${var.project}-${var.environment}-ap-server"
    Project = var.project
    Env     = var.environment
    Type    = "ap"
  }
}

#パラメータストア、DB接続情報
resource "aws_ssm_parameter" "host" {
  name  = "/${var.project}/${var.environment}/ap/MYSQL_HOST"
  type  = "String"
  value = aws_db_instance.mysql-standalone-instance.address
}

resource "aws_ssm_parameter" "port" {
  name  = "/${var.project}/${var.environment}/ap/MYSQL_PORT"
  type  = "String"
  value = aws_db_instance.mysql-standalone-instance.port
}

resource "aws_ssm_parameter" "database" {
  name  = "/${var.project}/${var.environment}/ap/MYSQL_DATABASE"
  type  = "String"
  value = aws_db_instance.mysql-standalone-instance.name
}

resource "aws_ssm_parameter" "username" {
  name  = "/${var.project}/${var.environment}/ap/MYSQL_USERNAME"
  type  = "SecureString"
  value = aws_db_instance.mysql-standalone-instance.username
}

resource "aws_ssm_parameter" "password" {
  name  = "/${var.project}/${var.environment}/ap/MYSQL_PASSWORD"
  type  = "SecureString"
  value = aws_db_instance.mysql-standalone-instance.password
}
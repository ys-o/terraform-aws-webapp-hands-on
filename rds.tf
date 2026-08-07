# パラメーターグループ
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.4"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# オプショングループ
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.4"
}

# サブネットグループ
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}

# パスワード用のランダム文字列生成
resource "random_string" "db_password" {
  length  = 16
  special = false
}

# rdsのdbインスタンス
resource "aws_db_instance" "mysql-standalone-instance" {
  engine         = "mysql"
  engine_version = "8.4.10"

  # 注意：RDSインスタンスの名前、他resourceのname相当
  identifier = "${var.project}-${var.environment}-mysql-standalone-instance"

  username = "admin"
  password = random_string.db_password.result

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false

  multi_az               = false
  availability_zone      = "us-east-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  # 他resoruceのname相当ではなく、データベース名（CREATE DATABASE ＊＊＊・・・の＊＊＊）
  name = "tastylog"

  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

  backup_window              = "04:00-05:00"
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00"
  auto_minor_version_upgrade = false

  deletion_protection = false
  skip_final_snapshot = true

  apply_immediately = true

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}
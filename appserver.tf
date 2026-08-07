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
  ami                         = data.aws_ami.app.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet_1a.id
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.ap_sg.id,
    aws_security_group.operation_sg.id
  ]

  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-ap-server"
    Project = var.project
    Env     = var.environment
    Type    = "ap"
  }
}
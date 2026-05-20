data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ubuntu_ami_owner]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "monitoring_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name        = var.key_name
    Environment = var.environment
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = aws_key_pair.monitoring_key.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/../scripts/install-app.sh", {
    project_name = var.project_name
  })

  tags = {
    Name        = "${var.project_name}-app-server"
    Role        = "app"
    Environment = var.environment
  }
}

resource "aws_instance" "monitoring" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.monitoring_sg.id]
  key_name                    = aws_key_pair.monitoring_key.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/../scripts/install-monitoring.sh", {
    app_private_ip        = aws_instance.app.private_ip
    monitoring_private_ip = "127.0.0.1"
    project_name          = var.project_name
  })

  depends_on = [aws_instance.app]

  tags = {
    Name        = "${var.project_name}-monitoring-server"
    Role        = "monitoring"
    Environment = var.environment
  }
}

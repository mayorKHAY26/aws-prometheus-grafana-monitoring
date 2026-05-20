resource "tls_private_key" "monitoring_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "monitoring_key" {
  key_name   = var.key_name
  public_key = tls_private_key.monitoring_key.public_key_openssh

  tags = {
    Name        = var.key_name
    Environment = var.environment
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.monitoring_key.private_key_pem
  filename        = "${path.module}/monitoring-key.pem"
  file_permission = "0400"
}
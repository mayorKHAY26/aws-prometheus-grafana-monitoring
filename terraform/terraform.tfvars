aws_region = "us-east-1"

project_name = "aws-monitoring"
environment  = "dev"

vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "us-east-1a"

instance_type = "t3.micro"

my_ip = "70.186.199.125/32"

key_name        = "monitoring-key"
public_key_path = "~/.ssh/monitoring-key.pub"
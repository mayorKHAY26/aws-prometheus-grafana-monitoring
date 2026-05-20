variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "aws-monitoring"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the public subnet."
  type        = string
  default     = "us-east-1a"
}

variable "my_ip" {
  description = "Your public IP address in CIDR format for SSH/Grafana access. Example: 1.2.3.4/32"
  type        = string
}

variable "key_name" {
  description = "Name for the AWS key pair."
  type        = string
  default     = "monitoring-key"
}

variable "public_key_path" {
  description = "Path to your public key file."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ubuntu_ami_owner" {
  description = "Canonical AWS account ID for Ubuntu AMIs."
  type        = string
  default     = "099720109477"
}

variable "create_backend_resources" {
  description = "Whether to create S3 backend bucket and DynamoDB lock table."
  type        = bool
  default     = false
}

variable "backend_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state if create_backend_resources is true."
  type        = string
  default     = "change-me-monitoring-tf-state-bucket"
}

variable "backend_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking if create_backend_resources is true."
  type        = string
  default     = "monitoring-terraform-locks"
}

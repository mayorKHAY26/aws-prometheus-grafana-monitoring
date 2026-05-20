variable "aws_region" {
  description = "AWS region for backend resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "aws-monitoring"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "backend_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform remote state"
  type        = string
}

variable "backend_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}
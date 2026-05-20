terraform {
  backend "s3" {
    bucket         = "aws-monitoring-tf-state-mayorkhay26-2026"
    key            = "aws-monitoring-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "aws-monitoring-terraform-locks"
    encrypt        = true
  }
}
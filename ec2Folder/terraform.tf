# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


  backend s3 {
    bucket = "terra-tut-state-buck"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-table"
  }
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.25.0"
    }
  }

  backend s3 {
    bucket = "lab01s3tf"
    key = "vpc/vpc-01.state"
    workspace_key_prefix="lab"
    region = "us-east-1"
  }

}
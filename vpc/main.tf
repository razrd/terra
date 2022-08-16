provider "aws" {
  # Configuration options
  region = var.main_region
  
}

locals {
  create_vpc = var.create_vpc
}


resource "aws_vpc" "vpc" {
    count = local.create_vpc ? 1 : 0
    cidr_block = var.cidr_block

    tags = merge(
      { "Name" = var.vpc_name }
    )
}
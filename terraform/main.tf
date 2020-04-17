provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "event-horizon-bucket"
    key    = "terraform/terraform.tfstate"
    region = "sa-east-1"
  }
}

resource "aws_vpc" "eh-sa-east-1-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "eh-sa-east-1-vpc"
  }
}

resource "aws_subnet" "eh-lab-sa-east-1a-public-subnet" {
  vpc_id                          = aws_vpc.eh-sa-east-1-vpc.id
  assign_ipv6_address_on_creation = false
  availability_zone               = "sa-east-1a"
  cidr_block                      = "10.0.2.0/24"
  map_public_ip_on_launch         = true

  tags = {
    Name = "eh-lab-sa-east-1a-public-subnet"
  }
}

resource "aws_subnet" "eh-lab-sa-east-1a-private-subnet" {
  vpc_id                          = aws_vpc.eh-sa-east-1-vpc.id
  assign_ipv6_address_on_creation = false
  availability_zone               = "sa-east-1a"
  cidr_block                      = "10.0.3.0/24"
  map_public_ip_on_launch         = false

  tags = {
    "Name" = "eh-lab-sa-east-1a-private-subnet"
  }
}

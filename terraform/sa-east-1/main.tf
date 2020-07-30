provider "aws" {
  version = "~> 2.0"
  region  = var.region
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "eh-sa-east-1-bucket"
    key    = "terraform/terraform.tfstate"
    region = "sa-east-1"
  }
}

// ============================================================================================== //
// VPCs
// ============================================================================================== //

resource "aws_vpc" "eh-sa-east-1-vpc" {
  assign_generated_ipv6_cidr_block = false
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "eh-sa-east-1-vpc"
  }
}

// ============================================================================================== //
// Subnets
// ============================================================================================== //

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
    Name = "eh-lab-sa-east-1a-private-subnet"
  }
}

// ============================================================================================== //
// Route Tables
// ============================================================================================== //

resource "aws_route_table" "eh-lab-sa-east-1a-public-subnet-route-table" {
  vpc_id = aws_vpc.eh-sa-east-1-vpc.id

  route = [
    {
      cidr_block                = "0.0.0.0/0"
      egress_only_gateway_id    = ""
      gateway_id                = aws_internet_gateway.eh-sa-east-1-vpc-internet-gateway.id
      instance_id               = ""
      ipv6_cidr_block           = ""
      nat_gateway_id            = ""
      network_interface_id      = ""
      transit_gateway_id        = ""
      vpc_peering_connection_id = ""
    }
  ]

  tags = {
    Name = "eh-lab-sa-east-1a-public-subnet-route-table"
  }
}


resource "aws_route_table" "eh-lab-sa-east-1a-private-subnet-route-table" {
  vpc_id = aws_vpc.eh-sa-east-1-vpc.id

  tags = {
    Name = "eh-lab-sa-east-1a-private-subnet-route-table"
  }
}

// ============================================================================================== //
// Internet Gateways
// ============================================================================================== //

resource "aws_internet_gateway" "eh-sa-east-1-vpc-internet-gateway" {
  vpc_id = aws_vpc.eh-sa-east-1-vpc.id

  tags     = {
    Name = "eh-sa-east-1-vpc-internet-gateway"
  }
}

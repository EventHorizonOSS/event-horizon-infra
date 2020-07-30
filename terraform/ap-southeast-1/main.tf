terraform {
  backend "s3" {
    bucket = "eh-ap-southeast-1-bucket"
    key    = "terraform/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = local.region
  profile = var.aws_profile
}

locals {
  region = "ap-southeast-1"
}

// ============================================================================================== //
// VPCs
// ============================================================================================== //

resource "aws_vpc" "eh-ap-southeast-1-vpc" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = "10.2.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    "Name" = "eh-ap-southeast-1-vpc"
  }
}

// ============================================================================================== //
// Internet Gateways
// ============================================================================================== //

resource "aws_internet_gateway" "eh-ap-southeast-1-vpc-internet-gateway" {
  vpc_id = aws_vpc.eh-ap-southeast-1-vpc.id

  tags = {
    Name = "eh-ap-southeast-1-vpc-internet-gateway"
  }
}

// ============================================================================================== //
// Route Tables
// ============================================================================================== //

resource "aws_route_table" "eh-ap-southeast-1-vpc-main-route-table" {
  propagating_vgws = []
  vpc_id           = aws_vpc.eh-ap-southeast-1-vpc.id

  route = [
    {
      cidr_block                = "0.0.0.0/0"
      egress_only_gateway_id    = ""
      gateway_id                = aws_internet_gateway.eh-ap-southeast-1-vpc-internet-gateway.id
      instance_id               = ""
      ipv6_cidr_block           = ""
      nat_gateway_id            = ""
      network_interface_id      = ""
      transit_gateway_id        = ""
      vpc_peering_connection_id = ""
    },
    {
      cidr_block                = "10.1.0.0/16"
      egress_only_gateway_id    = ""
      gateway_id                = ""
      instance_id               = ""
      ipv6_cidr_block           = ""
      nat_gateway_id            = ""
      network_interface_id      = ""
      transit_gateway_id        = ""
      vpc_peering_connection_id = "pcx-0fd2bbca241b9c551"
    }
  ]

  tags = {
    "Name" = "eh-ap-southeast-1-vpc-main-route-table"
  }
}

// ============================================================================================== //
// Subnets
// ============================================================================================== //

resource "aws_subnet" "eh-ap-southeast-1a-public-subnet" {
  vpc_id                          = aws_vpc.eh-ap-southeast-1-vpc.id
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1a"
  cidr_block                      = "10.2.0.0/24"
  map_public_ip_on_launch         = true

  tags = {
    Name = "eh-ap-southeast-1a-public-subnet"
  }
}

resource "aws_subnet" "eh-ap-southeast-1a-private-subnet" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1a"
  cidr_block                      = "10.2.1.0/24"
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.eh-ap-southeast-1-vpc.id

  tags = {
    Name = "eh-ap-southeast-1a-private-subnet"
  }
}

resource "aws_subnet" "eh-ap-southeast-1b-public-subnet" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1b"
  cidr_block                      = "10.2.2.0/24"
  map_public_ip_on_launch         = true
  vpc_id                          = aws_vpc.eh-ap-southeast-1-vpc.id

  tags = {
    Name = "eh-ap-southeast-1b-public-subnet"
  }
}

resource "aws_subnet" "eh-ap-southeast-1b-private-subnet" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1b"
  cidr_block                      = "10.2.3.0/24"
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.eh-ap-southeast-1-vpc.id

  tags = {
    Name = "eh-ap-southeast-1b-private-subnet"
  }
}

resource "aws_subnet" "eh-ap-southeast-1c-public-subnet" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1c"
  cidr_block                      = "10.2.4.0/24"
  map_public_ip_on_launch         = true
  vpc_id                          = aws_vpc.eh-ap-southeast-1-vpc.id

  tags = {
    Name = "eh-ap-southeast-1c-public-subnet"
  }
}

resource "aws_subnet" "eh-ap-southeast-1c-private-subnet" {
  assign_ipv6_address_on_creation = false
  availability_zone               = "ap-southeast-1c"
  cidr_block                      = "10.2.5.0/24"
  map_public_ip_on_launch         = false
  vpc_id                          = aws_vpc.eh-ap-southeast-1-vpc.id

  tags = {
    Name = "eh-ap-southeast-1c-private-subnet"
  }
}

// ============================================================================================== //
// Route Table Associations
// ============================================================================================== //

resource "aws_main_route_table_association" "eh-ap-southeast-1-vpc-main-route-table-association" {
  vpc_id         = aws_vpc.eh-ap-southeast-1-vpc.id
  route_table_id = aws_route_table.eh-ap-southeast-1-vpc-main-route-table.id
}

resource "aws_route_table_association" "eh-ap-southeast-1a-public-subnet-route-table-association" {
  subnet_id      = aws_subnet.eh-ap-southeast-1a-public-subnet.id
  route_table_id = aws_route_table.eh-ap-southeast-1-vpc-main-route-table.id
}

resource "aws_route_table_association" "eh-ap-southeast-1a-private-subnet-route-table-association" {
  subnet_id      = aws_subnet.eh-ap-southeast-1a-private-subnet.id
  route_table_id = aws_route_table.eh-ap-southeast-1-vpc-main-route-table.id
}

resource "aws_route_table_association" "eh-ap-southeast-1b-public-subnet-route-table-association" {
  subnet_id      = aws_subnet.eh-ap-southeast-1b-public-subnet.id
  route_table_id = aws_route_table.eh-ap-southeast-1-vpc-main-route-table.id
}

resource "aws_route_table_association" "eh-ap-southeast-1b-private-subnet-route-table-association" {
  subnet_id      = aws_subnet.eh-ap-southeast-1b-private-subnet.id
  route_table_id = aws_route_table.eh-ap-southeast-1-vpc-main-route-table.id
}

resource "aws_route_table_association" "eh-ap-southeast-1c-public-subnet-route-table-association" {
  subnet_id      = aws_subnet.eh-ap-southeast-1c-public-subnet.id
  route_table_id = aws_route_table.eh-ap-southeast-1-vpc-main-route-table.id
}

resource "aws_route_table_association" "eh-ap-southeast-1c-private-subnet-route-table-association" {
  subnet_id      = aws_subnet.eh-ap-southeast-1c-private-subnet.id
  route_table_id = aws_route_table.eh-ap-southeast-1-vpc-main-route-table.id
}

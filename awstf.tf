# Call AWS Provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Create the VPC

resource "aws_vpc" "asoc_prod_vpc_aps1" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "asoc_prod_vpc_aps1"
  }
}

# Adding Internet Gateway and attach it to VPC

resource "aws_internet_gateway" "asoc_prod_vpc_aps1_igw" {
  vpc_id = aws_vpc.asoc_prod_vpc_aps1.id

  tags = {
    Name = "asoc_prod_vpc_aps1_igw"
  }
}

# Subnets

resource "aws_subnet" "asoc_prod_vpc_fw_az1_pub_sn01" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.0.0/28"

  tags = {
    Name = "asoc_prod_vpc_fw_az1_pub_sn01"
  }
}

resource "aws_subnet" "asoc_prod_vpc_fw_az2_pub_sn02" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.0.16/28"

  tags = {
    Name = "asoc_prod_vpc_fw_az2_pub_sn02"
  }
}

resource "aws_subnet" "asoc_prod_vpc_gw_az1_pub_sn03" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.20.0/24"

  tags = {
    Name = "asoc_prod_vpc_gw_az1_pub_sn03"
  }
}

resource "aws_subnet" "asoc_prod_vpc_gw_az2_pub_sn04" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.40.0/24"

  tags = {
    Name = "asoc_prod_vpc_gw_az2_pub_sn04"
  }
}

resource "aws_subnet" "asoc_prod_vpc_app_az1_prv_sn05" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.21.0/24"

  tags = {
    Name = "asoc_prod_vpc_app_az1_prv_sn05"
  }
}

resource "aws_subnet" "asoc_prod_vpc_app_az2_prv_sn06" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.41.0/24"

  tags = {
    Name = "asoc_prod_vpc_app_az2_prv_sn06"
  }
}

resource "aws_subnet" "asoc_prod_vpc_wl_az1_prv_sn07" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.22.0/24"

  tags = {
    Name = "asoc_prod_vpc_wl_az1_prv_sn07"
  }
}

resource "aws_subnet" "asoc_prod_vpc_wl_az2_prv_sn08" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.42.0/24"

  tags = {
    Name = "asoc_prod_vpc_wl_az2_prv_sn08"
  }
}


resource "aws_subnet" "asoc_prod_vpc_as_az1_prv_sn09" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.23.0/24"

  tags = {
    Name = "asoc_prod_vpc_as_az1_prv_sn09"
  }
}

resource "aws_subnet" "asoc_prod_vpc_as_az2_prv_sn10" {
  vpc_id     = aws_vpc.asoc_prod_vpc_aps1.id
  cidr_block = "10.10.43.0/24"

  tags = {
    Name = "asoc_prod_vpc_as_az2_prv_sn10"
  }
}

# EIP Allocations
resource "aws_eip" "asoc_prod_vpc_aps1_nat_gw_az01_eip" {
  vpc = true
}

# NAT Gateway

resource "aws_nat_gateway" "asoc_prod_vpc_aps1_nat_gw_az01" {
  allocation_id = aws_eip.asoc_prod_vpc_aps1_nat_gw_az01_eip.id
  subnet_id     = aws_subnet.asoc_prod_vpc_gw_az1_pub_sn03.id

  tags = {
    Name = "asoc_prod_vpc_aps1_nat_gw_az01"
  }

  depends_on = [aws_internet_gateway.asoc_prod_vpc_aps1_igw]
}

# Route Tables

resource "aws_route_table" "asoc_prod_vpc_igw_rt" {
  vpc_id = aws_vpc.asoc_prod_vpc_aps1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.asoc_prod_vpc_aps1_igw.id
  }

  tags = {
    Name = "asoc_prod_vpc_igw_rt"
  }
}

resource "aws_route_table" "asoc_prod_vpc_app_rt_az1" {
  vpc_id = aws_vpc.asoc_prod_vpc_aps1.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.asoc_prod_vpc_aps1_nat_gw_az01.id
  }

  tags = {
    Name = "asoc_prod_vpc_app_rt_az1"
  }
}

resource "aws_route_table" "asoc_prod_vpc_app_rt_az2" {
  vpc_id = aws_vpc.asoc_prod_vpc_aps1.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.asoc_prod_vpc_aps1_nat_gw_az01.id
  }

  tags = {
    Name = "asoc_prod_vpc_app_rt_az2"
  }
}

# Route Table Associations

resource "aws_route_table_association" "igw_rt_association" {
  gateway_id     = aws_internet_gateway.asoc_prod_vpc_aps1_igw.id
  route_table_id = aws_route_table.asoc_prod_vpc_igw_rt.id
}

resource "aws_route_table_association" "sn01_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_fw_az1_pub_sn01.id
  route_table_id = aws_route_table.asoc_prod_vpc_igw_rt.id
}

resource "aws_route_table_association" "sn02_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_fw_az2_pub_sn02.id
  route_table_id = aws_route_table.asoc_prod_vpc_igw_rt.id
}

resource "aws_route_table_association" "sn03_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_gw_az1_pub_sn03.id
  route_table_id = aws_route_table.asoc_prod_vpc_igw_rt.id
}

resource "aws_route_table_association" "sn04_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_gw_az2_pub_sn04.id
  route_table_id = aws_route_table.asoc_prod_vpc_igw_rt.id
}

resource "aws_route_table_association" "sn05_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_app_az1_prv_sn05.id
  route_table_id = aws_route_table.asoc_prod_vpc_app_rt_az1.id
}

resource "aws_route_table_association" "sn06_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_app_az2_prv_sn06.id
  route_table_id = aws_route_table.asoc_prod_vpc_app_rt_az2.id
}

resource "aws_route_table_association" "sn07_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_wl_az1_prv_sn07.id
  route_table_id = aws_route_table.asoc_prod_vpc_app_rt_az1.id
}

resource "aws_route_table_association" "sn08_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_wl_az2_prv_sn08.id
  route_table_id = aws_route_table.asoc_prod_vpc_app_rt_az2.id
}

resource "aws_route_table_association" "sn09_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_as_az1_prv_sn09.id
  route_table_id = aws_route_table.asoc_prod_vpc_app_rt_az1.id
}

resource "aws_route_table_association" "sn10_rt_association" {
  subnet_id      = aws_subnet.asoc_prod_vpc_as_az2_prv_sn10.id
  route_table_id = aws_route_table.asoc_prod_vpc_app_rt_az2.id
}

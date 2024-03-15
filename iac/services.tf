# Define the provider and version
provider "aws" {
  region  = "us-east-1" # You can change this to your desired AWS region
  version = "~> 3.0"    # Specifies the version of the AWS provider you want to use
}

# Create a new instance of the VPC resource
resource "aws_vpc" "my_vpc" {
  # checkov:skip=CKV2_AWS_11: ADD REASON
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my-internet-gateway"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "my-subnet"
  }
}

# Specify an AWS EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI ID, you should use an AMI ID that matches your requirements
  instance_type = "t2.micro"             # Specifies the instance type

  subnet_id = aws_subnet.my_subnet.id    # Associates the instance with the subnet

  tags = {
    Name = "MyInstance"
  }
}

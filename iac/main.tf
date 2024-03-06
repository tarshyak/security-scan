# Minimal misconfigured tf file
terraform {  
    required_version = ">= 0.12"
}
provider "aws" {  
    region = "eu-west-1"
}
resource "aws_instance" "example" {  
    ami = "ami-0c55b159cbfafe1f0"  
    instance_type = "t2.micro"  
    tags = {    
        Name = "example-instance"  
    }
}
output "public_ip" {  
    value = aws_instance.example.public_ip
}

provider "aws" {
    region = "us-west-1"
}

variable "subnet_cidr_block" {
    description = "subnet cidr block"
    default = "10.0.10.0/24"
    type = string
} 

variable "vpc_cidr_block" {
    description = "vpc cidr block"
} 

resource "aws_vpc" "development-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "development"
        vpc_env: "dev"
    }
}

resource "aws_subnet" "development-subnet-1" {
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.subnet_cidr_block
    tags = {
        Name: "subnet-development-1"
    }
}

data "aws_vpc" "existing_vpc" {
    default = true
}

resource "aws_subnet" "development-subnet-2" {
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = "172.31.48.0/20"
    tags = {
        Name: "subnet-default-1"
    }
}

output "vpc-id" {
    value = "aws_vpc.development-vpc.id"
}

output "subnet-id" {
    value = "aws_subnet.development-subnet-1.id"
}
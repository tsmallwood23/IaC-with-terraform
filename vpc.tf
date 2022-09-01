provider "aws" {
    region = "us-west-1"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "azs" {}

module "myapp-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"
  # insert the 23 required variables here

  name = "myapp-vpc"
  cidr = var.vpc_cidr_block
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets = var.public_subnet_cidr_blocks
  azs = data.aws_availability_zones.azs.names
    #to be able to query the azs dynamically so our resources get duplicated to all available ones we do this. we use the data query then call the result. note the provider and region must also be set
  
  enable_nat_gateway = true
  #enabled by default but added for clarity
  single_nat_gateway = true
  #all private subnets will route their internet traffic through this single nat
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"

  }

  public_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
    #for the cloud native load balancer
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    "kubernetes.io/role/internal=elb" = 1
    #for the load balancer inside the cluster
  }
}
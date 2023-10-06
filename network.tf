terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
  }
}

provider "aws" {
  # Configuration options

  region = var.aws_region

}

################################################################
# DATA
################################################################
data "aws_availability_zones" "available" {
  state = "available"
}

################################################################
# NETWORKING
################################################################

resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-vpc" })

}


resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id

}

resource "aws_subnet" "my-subnets" {
  count                   = var.vpc_subnet_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = local.common_tags
}

/*resource "aws_subnet" "my-subnet2" {
  cidr_block              = var.vpc_subnets_cidr_block[1]
  vpc_id                  = aws_vpc.my-vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = local.common_tags
}*/



###################################################################
# ROUTING
###################################################################

resource "aws_route_table" "my-rtb" {
  vpc_id = aws_vpc.my-vpc.id

  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id


  }
}

resource "aws_route_table_association" "rta-subnets" {
  count          = var.vpc_subnet_count
  subnet_id      = aws_subnet.my-subnets[count.index].id
  route_table_id = aws_route_table.my-rtb.id
}

/*resource "aws_route_table_association" "rt-mysubnet2" {
  subnet_id      = aws_subnet.my-subnet2.id
  route_table_id = aws_route_table.my-rtb.id
}*/
# SECURITY GROUPS #

resource "aws_security_group" "ngnix-sg" {
  name   = "ngnix-sg"
  vpc_id = aws_vpc.my-vpc.id

  #HTTPS access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-dev" })

}
##  ALB SECURITY GROUP #

resource "aws_security_group" "alb_sg" {
  name   = "ngnix_alb_sg"
  vpc_id = aws_vpc.my-vpc.id

  #HTTPS access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}





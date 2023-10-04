## variable "aws_access_key" {
#   type = string
#  description = "AWS access key"
# sensitive = true

## }

## variable "aws_secret_key" {
# type = string
# description = "AWS secret key"
# sensitive = true

## } 

variable "aws_region" {
  type        = string
  description = "AWS regions for resources"
  default     = "us-east-1"

}

variable "enable_dns_hostnames" {
  type        = bool
  description = "enable dns hostnames in a Vpc"
  default     = true

}


variable "map_public_ip_on_launch" {
  type        = string
  description = "map public ip for an instance"
  default     = true

}

variable "instance_type" {
  type        = string
  description = "instance_type for an ec2 instance"
  default     = "t2.micro"

}

variable "instance_count" {
  type = number
  description = "Number of instances to be created"
  default = 2
  
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr_block for the vpc"
  default     = "10.0.0.0/16"

}

variable "vpc_subnet_count"{
  type        = number
  description = "number of subnets in a VPC"
  default = 2
}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "cidr_block for the my-subnet subnet"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]


}

variable "Billing_code" {
  type        = string
  description = "Billing code for the resource tagging"

}

variable "project" {
  type        = string
  description = "project for resource tagging"

}


variable "company_name" {
  type        = string
  description = "company name for resource tagging"
  default     = "Globomantics"
}
provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
  version = "~> 2.25"
}

# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = var.vpc_instance_tenancy
  tags = var.tags
}

resource "aws_subnet" "public" {
  for_each = var.subnet_numbers

  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, each.value)
  map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags
}
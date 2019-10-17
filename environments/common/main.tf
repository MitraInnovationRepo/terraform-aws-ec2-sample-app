provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
  version = "~> 2.25"
}

module "label" {
  source = "git::https://github.com/MitraInnovationRepo/terraform-aws-codepipeline.git//modules/aws-label?ref=tags/v0.2.1-lw"
  namespace = var.namespace
  name = var.name
  stage = var.stage
  tags = var.tags
  attributes = var.attributes
  delimiter = var.delimiter
}

# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  instance_tenancy = var.vpc_instance_tenancy
  tags = var.tags
}

//resource "aws_subnet" "public" {
//  for_each = var.subnet_numbers
//
//  vpc_id            = aws_vpc.this.id
//  availability_zone = each.key
//  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, each.value)
//  map_public_ip_on_launch = "true"
//}

resource "aws_subnet" "public" {
  cidr_block = var.subnet_cidr_block
  vpc_id = aws_vpc.this.id
  availability_zone = "us-east-2a"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  tags = var.tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  route_table_id = aws_route_table.this.id
  subnet_id = aws_subnet.public.id
}


# Security Group
resource "aws_security_group" "this" {
  name = "${module.label.id}${var.delimiter}sg"
  description = "Allow TLS inbound traffic"

  vpc_id = aws_vpc.this.id
}

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.this.id
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [
    "202.124.175.194/32"
  ]
}

resource "aws_security_group_rule" "http_app" {
  security_group_id = aws_security_group.this.id
  type = "ingress"
  from_port = 9090
  to_port = 9090
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

resource "aws_security_group_rule" "allow_out_all" {
  security_group_id = aws_security_group.this.id
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}





# IAM Role with policy AmazonEC2RoleforAWSCodeDeploy
# IAM Role for the CodePipeline
resource "aws_iam_role" "this" {
  name = "${module.label.id}${var.delimiter}ec2"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        Effect: "Allow",
        Principal: {
          "Service": "ec2.amazonaws.com"
        },
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  role = aws_iam_role.this.name
}

resource "aws_iam_instance_profile" "this" {
  name = "${module.label.id}${var.delimiter}ec2${var.delimiter}instance${var.delimiter}profile"
  role = aws_iam_role.this.name
}


# AMI for Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name = "owner-alias"
    values = [
      "amazon"
    ]
  }


  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm*"
    ]
  }

  owners = [
    "137112412989"
  ]
}

# EC2 instance
resource "aws_instance" "this" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.this.name

  # install CodeDeploy agent and Java 8
  user_data = file("../../resources/user_data.sh")

  key_name = "ec2-java"
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = "true"

  tags = var.tags
}
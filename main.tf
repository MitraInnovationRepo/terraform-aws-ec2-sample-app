provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
  version = "~> 2.25"
}

locals {
  codepipeline_codedeploy_ec2_tag_filters = [
  for tag_key in keys(var.tags):
  {
    key = tag_key
    value = lookup(var.tags, tag_key)
    type = lookup(var.tags, tag_key) != "" ? (tag_key != "" ? "KEY_AND_VALUE" : "VALUE_ONLY") : "KEY_ONLY"
  }
  ]
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

# Security Group
resource "aws_security_group" "this" {
  name = "${module.label.id}${var.delimiter}sg"
  description = "Allow TLS inbound traffic"
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
  user_data = file("${path.module}/resources/user_data.sh")

  key_name = "ec2-java"
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]
  associate_public_ip_address = "true"

  tags = var.tags
}

module "mitrai_setf_codepipeline" {
  source = "git::https://github.com/MitraInnovationRepo/terraform-aws-codepipeline.git?ref=tags/v0.2.2-lw"
  name = var.name
  namespace = var.namespace
  stage = var.stage
  tags = var.tags
  attributes = var.attributes

  github_organization = "MitraInnovationRepo"
  github_repository = "hello-spring-boot"
  github_repository_branch = "dev"
  github_token = "2355e4918e840f270d170357fdbb4f6e347e94ca"
  github_webhook_events = [
    "push"
  ]

  webhook_filters = [
    {
      json_path = "$.ref"
      match_equals = "refs/heads/{Branch}"
    }
  ]

  codebuild_description = "SETF CodeBuild Sample Java Application"
  codebuild_buildspec = file("${path.module}/resources/buildspec.yml")
  codebuild_build_environment_compute_type = "BUILD_GENERAL1_SMALL"
  codebuild_build_environment_image = "aws/codebuild/standard:1.0"
  codebuild_build_timeout = "5"
  codedeploy_deployment_config_name = "CodeDeployDefault.OneAtATime"

  codedeploy_ec2_tag_filters = local.codepipeline_codedeploy_ec2_tag_filters
}
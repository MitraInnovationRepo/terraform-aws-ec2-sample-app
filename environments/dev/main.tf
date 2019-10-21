provider "aws" {
  profile = "default"
  region = "us-east-2"
  version = "~> 2.25"
}

module "development_environment" {
  source = "../../modules/environments_common"

  stage = "develop"
  tags = {
    "Name" = "SETF-Dev-Setup"
  }
  attributes = [
    "SETF"
  ]

  github_repository_branch = "dev"
  github_webhook_events = [
    "push"
  ]
  webhook_filters = [
    {
      json_path = "$.ref"
      match_equals = "refs/heads/{Branch}"
    }
  ]
  github_token = var.github_token

  vpc_cidr_block = "10.1.0.0/16"
  subnet_cidr_block = "10.1.1.0/24"
}
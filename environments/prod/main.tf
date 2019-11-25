provider "aws" {
  profile = "default"
  region = "us-east-2"
  version = "~> 2.25"
}

module "production_environment" {
  source = "../../modules/environments_common"

  stage = "production"
  tags = {
    "Name" = "SETF-Prod-Setup"
  }
  attributes = [
    "SETF"
  ]

  github_repository_branch = "master"
  github_webhook_events = [
    "release"
  ]
  webhook_filters = [
    {
      json_path = "$.action"
      match_equals= "published"
    }
  ]
  github_token = var.github_token
  
  vpc_cidr_block = "10.2.0.0/16"
  subnet_cidr_block = "10.2.1.0/24"
}
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
locals {
  namespace = "mitrai"
  name = "sample"
  stage = var.stage

  tags = merge({
    BusinessUnit = "DIGITAL"
    Team = "SETF"
  }, var.tags)

  attributes = concat([
    "sample"
  ], var.attributes)

  delimiter = "-"
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

module "ec2_vpc_setup" {
  source = "../ec2_vpc_setup"

  namespace = local.namespace
  name = local.name
  stage = local.stage
  tags = local.tags
  attributes = local.attributes
  delimiter = local.delimiter

  vpc_cidr_block = var.vpc_cidr_block
  subnet_cidr_block = var.subnet_cidr_block
}

module "mitrai_setf_codepipeline" {
  source = "git::https://github.com/MitraInnovationRepo/terraform-aws-codepipeline.git?ref=tags/v0.2.2-lw"

  namespace = local.namespace
  name = local.name
  stage = local.stage
  tags = local.tags
  attributes = local.attributes
  delimiter = local.delimiter

  github_organization = "MitraInnovationRepo"
  github_repository = "hello-spring-boot"
  github_repository_branch = var.github_repository_branch
  github_token = var.github_token
  github_webhook_events = var.github_webhook_events
  webhook_filters = var.webhook_filters

  codebuild_description = "SETF CodeBuild Sample Java Application"
  codebuild_buildspec = file("../../resources/buildspec.yml")
  codebuild_build_environment_compute_type = "BUILD_GENERAL1_SMALL"
  codebuild_build_environment_image = "aws/codebuild/standard:1.0"
  codebuild_build_timeout = "5"

  codedeploy_deployment_config_name = "CodeDeployDefault.OneAtATime"
  codedeploy_ec2_tag_filters = local.codepipeline_codedeploy_ec2_tag_filters
}
variable "stage" {
  type = "string"
  default = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev'"
}

variable "tags" {
  type = map(string)
  default = {}
  description = "Tags (e.g. `map('BusinessUnit','ABC')`"
}

variable "attributes" {
  type = list(string)
  default = []
  description = "Additional attributes (e.g. `1`)"
}

variable "github_repository_branch" {
  type = "string"
  default = ""
  description = "GitHub repository branch name"
}

variable "github_token" {
  type = "string"
  default = ""
  description = "GitHub auth token"
}

variable "github_webhook_events" {
  type = "list"
  default = [
    "push"
  ]
  description = "A list of events which should trigger the webhook. See a list of available events at `https://developer.github.com/v3/activity/events/types/`"
}

variable "webhook_filters" {
  type = "list"
  default = [
    {
      json_path = "$.ref"
      match_equals = "refs/heads/{Branch}"
    }
  ]
  description = <<EOF
    A list of filters with JSON path and value to match on.
      The JSON path to filter on `https://github.com/json-path/JsonPath`.
      For matching value see AWS docs for details `https://docs.aws.amazon.com/codepipeline/latest/APIReference/API_WebhookFilterRule.html`
  EOF
}

variable "codedeploy_ec2_tag_filters" {
  type = "list"
  default = []
  description = "Tag filters associated with the deployment group. e.g. [{key = PROD value = PRODUCTION type = KEY_AND_VALUE}]"
}

# VPC
variable "vpc_cidr_block" {
  type = "string"
  default = ""
  description = "The CIDR block for the VPC"
}

variable "vpc_instance_tenancy" {
  type = "string"
  default = "default"
  description = "A tenancy option for instances launched into the VPC"
}

variable "subnet_cidr_block" {
  type = "string"
  default = ""
  description = "The CIDR block for the VPC"
}

variable "subnet_numbers" {
  description = "Map from availability zone to the number that should be used for each availability zone's subnet"
  default     = {
    "eu-west-1a" = 1
    "eu-west-1b" = 2
    "eu-west-1c" = 3
  }
}
# Solution descriptive variables
variable "name" {
  type = "string"
  default = "codepipeline-project"
  description = "Name of the solution"
}

variable "namespace" {
  type = "string"
  default = ""
  description = "Name of the organization"
}

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

variable "delimiter" {
  type = "string"
  default = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
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
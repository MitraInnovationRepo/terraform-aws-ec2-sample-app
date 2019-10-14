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
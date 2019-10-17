module "dev_vpc" {
  source = "../common"

  aws_region = "us-east-2"
  name = "sample"
  namespace = "mitrai"
  stage = "develop"
  tags = {
    "BusinessUnit" = "DIGITAL"
    "Team" = "SETF"
    "Name" = "SETF-DEV"
  }
  attributes = ["SETF"]

  vpc_cidr_block = "10.1.0.0/16"
  subnet_cidr_block = "10.1.1.0/24"
}
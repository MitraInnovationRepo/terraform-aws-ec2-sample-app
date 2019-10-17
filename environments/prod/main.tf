module "dev_vpc" {
  source = "../common"

  aws_region = "us-east-2"
  name = "sample"
  namespace = "mitrai"
  stage = "production"
  tags = {
    "BusinessUnit" = "DIGITAL"
    "Team" = "SETF"
    "Name" = "SETF-PROD"
  }
  attributes = ["SETF"]

  vpc_cidr_block = "10.2.0.0/16"
  subnet_cidr_block = "10.2.1.0/24"
}
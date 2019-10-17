# terraform-aws-ec2-sample-app
Sample application in order to use the Terraform AWS pipeline 

## 1. Steps

### 1.1. Build Pipeline

Create `terraform.tfvars` file in the directory `pipeline` and add following.
```hcl-terraform
aws_region = "us-east-2"
aws_profile = "default"

name = "sample"
namespace = "mitrai"
stage = "develop"
tags = {
  "BusinessUnit" = "DIGITAL"
  "Team" = "SETF"
}
attributes = ["SETF"]
```

Execute following
```bash
cd pipeline
terraform init
terraform apply
```

### 1.2. Spin Environments

#### 1.2.1. Development Environment

Execute following
```bash
cd environments/dev
terraform init
terraform apply
```

#### 1.2.1. Production Environment

Execute following
```bash
cd environments/prod
terraform init
terraform apply
```
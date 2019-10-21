# terraform-aws-ec2-sample-app
Sample application in order to use the Terraform AWS pipeline 

## 1. Steps

### 1.1. Setup github token in environments

Create `terraform.tfvars` file in the directories `environments/dev` and `environments/prod`. Add the github token value as follows.
```hcl-terraform
github_token = "*******************************************"
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
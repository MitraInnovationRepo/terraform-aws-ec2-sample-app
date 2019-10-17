# terraform-aws-ec2-sample-app
Sample application in order to use the Terraform AWS pipeline 

## 1. Steps
### 1.1. Build Pipeline

```bash
cd pipeline
terraform init
terraform apply
```

### 1.2. Spin Environments

#### 1.2.1. Development Environment
```bash
cd environments/dev
terraform init
terraform apply
```

#### 1.2.1. Production Environment
```bash
cd environments/prod
terraform init
terraform apply
```
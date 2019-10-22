# Terraform AWS EC2 Sample App

Sample application that uses the terraform module: [terraform-aws-codepipeline](https://github.com/MitraInnovationRepo/terraform-aws-codepipeline).

## 1. Steps to Run Full Setup

### 1.1. Setup GitHub token in environments

1. Visit https://github.com/settings/tokens and create a GitHub token.
1. Add the GitHub token with creating files `environments/dev/terraform.tfvars` and `environments/prod/terraform.tfvars`

```hcl-terraform
github_token = "*******************************************"
```

### 1.2. Spin Environments

#### 1.2.1. Development Environment

Execute following in the directory `environments/dev` to spin the development environment.

```bash
terraform init
terraform apply
```

You can start the pipeline with committing to the branch `dev` in the repository.

#### 1.2.1. Production Environment

Execute following in the directory `environments/prod` to spin the  production environment.

```bash
terraform init
terraform apply
```

#### 1.2.2 Destroy Environments

Execute the following in the two directories `environments/dev` and `environments/prod` to destroy both environments.

```bash
terraform destroy
```

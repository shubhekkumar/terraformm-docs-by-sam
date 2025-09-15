# Terraform on AWS — Create an EC2 instance (step‑by‑step)

This guide documents the exact steps to provision and destroy an AWS EC2 instance using Terraform.

---

## 1) AWS account and IAM user setup

1. Create an AWS account.
2. Create a new IAM user.
   - Add the user to a group.
   - Attach **AdministratorAccess** permission.
3. Enable MFA for the IAM user.
4. Create an access key for the IAM user and download the credentials.

---

## 2) Install and configure AWS CLI on Windows

1. Install AWS CLI.
2. Verify installation:

```bash
aws --version
```

3. Configure AWS CLI:

```bash
aws configure
```

Provide:
- Access Key ID
- Secret Access Key
- Region
- Output format

4. Verify configuration:

```bash
aws iam list-users
```

---

## 3) Terraform project setup

1. Create a project folder `aws-ec2`.
2. Inside it, create the following file:

### `main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"  # main line specifying AWS provider
      version = "6.13.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"   # higher level property
}

resource "aws_instance" "tf-server" {
  ami           = "ami-0fd2b85ee2b4dc969"
  instance_type = "t3.nano"

  tags = {
    Name = "Sample server"
  }
}
```

---

## 4) Terraform workflow

Run the following commands inside the `aws-ec2` folder:

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Create a plan
terraform plan

# Apply configuration
terraform apply

# Make changes if required in main.tf and re-apply
terraform apply

# Destroy resources when finished
terraform destroy
```

---

## Summary

- IAM user created with admin access and MFA.
- AWS CLI installed and configured with credentials.
- Terraform project created with `main.tf`.
- Commands run: `terraform init`, `terraform plan`, `terraform validate`, `terraform apply`, `terraform destroy`.

This completes the lifecycle of creating and managing an EC2 instance using Terraform.


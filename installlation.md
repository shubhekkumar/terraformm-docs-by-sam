# Terraform Installation and Basics

## 1. Introduction to Terraform
**What:** Terraform is an open-source Infrastructure as Code (IaC) tool by HashiCorp.  
**Why:** It lets you manage infrastructure declaratively. It is version-controlled, consistent, and reproducible.  
**How:** You write `.tf` files and use commands like `terraform init`, `terraform plan`, `terraform apply`.

**Example:**
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
2. Core Concepts
Providers: Plugins for cloud/services (AWS, Azure, GCP, Kubernetes, etc.).

Resources: Infrastructure elements (EC2, S3, VPC).

Data Sources: Read existing infra details.

State: Tracks infra in a .tfstate file.

Variables: Input values for reusability.

Outputs: Export values after infra creation.

3. Workflow
terraform init → setup provider

terraform plan → preview changes

terraform apply → create/update infra

terraform destroy → remove infra

4. Variables and Outputs
What: Make code reusable and parameterized.

Example:

hcl
Copy code
variable "instance_type" {
  default = "t2.micro"
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
}

output "instance_id" {
  value = aws_instance.web.id
}
5. State Management
Local state file: terraform.tfstate

Remote state: S3, GCS, etc. for team collaboration

State locking: Prevents conflicts when multiple users work

6. Modules
What: Group of Terraform configs packaged for reuse.
Why: Avoid duplicate code.
How: Use module blocks.

Example:

hcl
Copy code
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0"
  name    = "my-vpc"
  cidr    = "10.0.0.0/16"
}
7. Provisioners
Provisioners run scripts on resources after creation.

Example:

hcl
Copy code
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y nginx"
  ]
}
8. Terraform CLI Commands
terraform fmt → format code

terraform validate → check syntax

terraform taint → mark resource for recreation

terraform refresh → sync state

9. Intermediate Topics
Workspaces: Manage environments (dev, prod).

Lifecycle Rules: Control create/destroy/update behavior.

Dependencies: Use depends_on.

Terraform Registry: Public modules and providers.

Import: Bring existing infra under Terraform control.

10. Best Practices
Use .tfvars files for sensitive values.

Use remote state with locking.

Organize infra with modules.

Always run terraform plan before apply.

Pin versions for providers and modules.

pgsql
Copy code

Do you want me to also add **installation steps for Terraform (Windows/Linux/macOS)** to this file, or keep

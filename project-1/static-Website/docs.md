# Deploy Static Website on AWS Using S3

This guide explains how to deploy a static website to AWS using **Terraform** and **Amazon S3**.

---

## Provider Configuration

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"   # AWS provider
      version = "6.13.0"
    }
    random = {
      source  = "hashicorp/random" # Random provider to generate unique IDs
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "eu-north-1"  # AWS Region
}



aws provider → connects Terraform with AWS.
random provider → generates unique strings (used in bucket naming).

**Generate Random ID**
resource "random_id" "rand_id" {
  byte_length = 8
}

Creates a random 8-byte hex string.
Used to ensure bucket name uniqueness.

**S3 Bucket Creation**
resource "aws_s3_bucket" "mywebapp-Bucket" {
  bucket = "mywebapp-bucket-${random_id.rand_id.hex}"
}

Creates a new S3 bucket with a globally unique name.
Bucket name format: mywebapp-bucket-{random-id}.


**Public Access Configuration**
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mywebapp-Bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

Ensures the bucket is publicly accessible for hosting a website.


**Bucket Policy (Public Read)**
resource "aws_s3_bucket_policy" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-Bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.mywebapp-Bucket.id}/*"
      }
    ]
  })
}


Grants public read access to all objects in the bucket.

**Website Configuration**
resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.mywebapp-Bucket.id

  index_document {
    suffix = "index.html"
  }
}


Configures the S3 bucket for static website hosting.
Default landing page is index.html.

**Upload Files**
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.mywebapp-Bucket.bucket
  source       = "./index.html"
  key          = "index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "style_css" {
  bucket       = aws_s3_bucket.mywebapp-Bucket.bucket
  source       = "./style.css"
  key          = "style.css"
  content_type = "text/css"
}


Uploads index.html and style.css to the bucket.
Sets the correct MIME type for each file.

**Output Website Endpoint**
output "name" {
  value = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
}


Displays the public website endpoint after deployment.

**Example Hosted URL**
Your website will be accessible at:
http://mywebapp-bucket-db0d2e34d9254b78.s3-website.eu-north-1.amazonaws.com/


**Format:**
http://{your-bucket-name}.s3-website.{region}.amazonaws.com/

**Summary of Resources**

aws_s3_bucket.mywebapp-Bucket → Creates the S3 bucket.
aws_s3_bucket_public_access_block.example → Manages bucket public access.
aws_s3_bucket_policy.mywebapp → Grants public read access.
aws_s3_bucket_website_configuration.mywebapp → Enables static hosting.
aws_s3_object.index_html → Uploads index.html.
aws_s3_object.style_css → Uploads style.css.
output.name → Prints the hosted website URL.


****✅ With this Terraform configuration, you have deployed a fully working static website on AWS S3.****

****Terraform Workflow****
**1. Initialize Terraform**
terraform init

Downloads required providers (aws, random).
Prepares Terraform backend.

**2. Validate Configuration**
terraform validate

Checks syntax and configuration validity.

**3. Plan Deployment**
terraform plan

Shows execution plan before applying.

**4. Apply Deployment**
terraform apply -auto-approve

Creates the S3 bucket.
Uploads files.
Configures static website hosting.
Prints the website endpoint.

**5. Access Website**

Open the output URL in a browser.

**6. Destroy Infrastructure (optional)**
terraform destroy -auto-approv

Deletes all resources created by this configuration.

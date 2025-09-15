terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"  // the main thing is this line 
      version = "6.13.0"
    }
  }
}

provider "aws" {
  # Configuration options    here we provide hiher level properties like region
    region = var.region
}
resource "aws_instance" "tf-server" {
  ami = "ami-0fd2b85ee2b4dc969"
  instance_type = "t3.nano"

  tags = {
    Name = "Sample server"
  }
} 
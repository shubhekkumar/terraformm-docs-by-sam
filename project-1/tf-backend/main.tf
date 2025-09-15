terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"  // the main thing is this line 
      version = "6.13.0"
    }
  }
  backend "s3" {
    bucket = "demo-bucket-30bfbbf9b3ee7c91"
    key = "backend.tfstate"
    region = "eu-north-1"
  }
}

provider "aws" {
  # Configuration options    here we provide hiher level properties like region
    region = "eu-north-1"
}
resource "aws_instance" "tf-server" {
  ami = "ami-0fd2b85ee2b4dc969"
  instance_type = "t3.nano"

  tags = {
    Name = "Sample server"
  }
} 
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"  // the main thing is this line 
      version = "6.13.0"
    }
  }
}
provider "aws" {
    region = "eu-north-1"
}
resource "random_id" "rand_id" {
  byte_length = 8
}
resource "aws_s3_bucket" "demo-Bucket" {
  bucket = "demo-bucket-${random_id.rand_id.hex}"
}
resource "aws_s3_object" "bucket_data" {
  bucket = aws_s3_bucket.demo-Bucket.bucket
  source = "./myfile.txt"
  key = "mydata.txt"
}
output "name" {
  value = random_id.rand_id.hex
}
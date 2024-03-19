provider "aws" {
  region = "us-east-1" # Choose your AWS region
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-public-bucket-unique-name" # Bucket names must be unique across all existing bucket names in Amazon S3

  acl    = "public-read" # Sets the bucket to be publicly readable

  # It's important to explicitly allow public access in case the AWS account has block public access settings enabled.
  # The following settings ensure that the bucket policies allow public access.
  public_access_block_configuration {
    block_public_acls   = false
    ignore_public_acls  = false
    block_public_policy = false
    restrict_public_buckets = false
  }

  tags = {
    Name = "Public Bucket"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.public_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.public_bucket.arn
}

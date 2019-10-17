# Zip the Lambda function.

data "archive_file" "source" {
  output_path = var.lambda_zip
  source_file = "${path.module}/${var.source_dir}/${var.lambda_source}"
  type        = "zip"
}

# Create the S3 Bucket.

resource "aws_s3_bucket" "create-bucket" {
  acl    = "private"
  bucket = var.s3_bucket_name

  force_destroy = true

  tags = {
    Environment = "Dev"
    Name        = "Lambda Powerdown"
  }

  versioning {
    enabled = true
  }
}

# Upload the object (zip file) to our S3 bucket.

resource "aws_s3_bucket_object" "object-upload" {
  bucket = aws_s3_bucket.create-bucket.id
  key    = var.lambda_zip
  source = data.archive_file.source.output_path
}

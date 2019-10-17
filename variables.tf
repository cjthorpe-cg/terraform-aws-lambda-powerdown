variable "app_version" {
  default = "1.0.1"
}

variable "function_name" {
  default = "powerdown-ec2"
}

variable "lambda_source" {
  default = "powerdown-ec2.py"
}

variable "lambda_zip" {
  default = "powerdown-ec2.zip"
}

variable "runtime" {
  default = "python3.6"
}

variable "s3_bucket_name" {
  default = "lambda-powerdown"
}

variable "source_dir" {
  default = "source"
}

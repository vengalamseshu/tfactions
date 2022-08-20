/*terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}*/

provider "aws" {
  region = var.region
}


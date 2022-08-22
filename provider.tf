terraform {
  backend "s3" {
    bucket = "tfworkflow"
    key    = "ghactions/"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.region
}


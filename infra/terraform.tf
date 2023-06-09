terraform {
  required_version = ">=1.4.6"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.1.0"
    }

    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "tls" {}

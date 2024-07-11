terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.31.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.14.0"
    }
  }

  backend "s3" {
    bucket = "zuru-dev-terraform-state"
    key    = "terraform-module"
    region = "us-east-1"
  }

}

provider "aws" {
  region  = var.region
  profile = "default"
}


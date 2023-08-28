terraform {
  cloud {
    organization = "just-boxey-things"
    workspaces {
      name = "aws-compute"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.6"
}
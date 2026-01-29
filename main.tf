terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    bucket = "my-terraform-bucket4413"
    key    = "terraform/terraformstatefile.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./module/vpc"

  vpc_cidr            = var.vpc_cidr
  cluster_name        = var.cluster_name
  private_subnet_cidr = local.private_subnet_cidr
  public_subnet_cidr  = local.public_subnet_cidr
  region              = var.region
}


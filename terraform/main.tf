# Configure environment for SYS-360 Final Project

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47"
    }
  }

  backend "s3" {
    # store tfstate in S3 bucket instead of locally
    bucket  = "sys-final-tfstate"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-1"
    profile = "voclab"
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "voclab"
  default_tags {
    tags = var.tags_common
  }
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = var.ssh_key_name
  public_key = var.ssh_public_key
}

module "webserver" {
  source = "./webserver"

  ssh_key_name = var.ssh_key_name
  vpc_id       = aws_vpc.lamp-vpc.id
  subnet_id    = aws_subnet.public.id
}

module "jumpbox" {
  source = "./jumpbox"

  ssh_key_name = var.ssh_key_name
  vpc_id       = aws_vpc.lamp-vpc.id
  subnet_id    = aws_subnet.public.id
}

module "mariadb" {
  source = "./mariadb"

  ssh_key_name = var.ssh_key_name
  vpc_id       = aws_vpc.lamp-vpc.id
  subnet_id    = aws_subnet.private.id
}


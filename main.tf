provider "aws" {
  region              = "ap-south-1"
  version             = "3.5.0"
  allowed_account_ids = ["774974967276"]
}

module "vpc" {
  source = "./modules/vpc"

  name               = var.cluster_name
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  cluster_names      = var.cluster_names
}

module "iam" {
  source = "./modules/iam"

  service_role_name = "eksServiceRole-${var.cluster_name}"
  node_role_name    = "EKSNode-${var.cluster_name}"
}

module "cluster" {
  source = "./modules/cluster"

  name = var.cluster_name

  vpc_config = module.vpc.config
  iam_config = module.iam.config

  aws_auth_role_map = var.aws_auth_role_map
  aws_auth_user_map = var.aws_auth_user_map

  envelope_encryption_enabled = var.envelope_encryption_enabled
}

module "node_group" {
  source = "./modules/asg_node_group"

  cluster_config = module.cluster.config
}

#resource "aws_s3_bucket" "tf-snaptrude" {
#    bucket = "tf-snaptrude"
#    acl = "private"
#}

terraform {
  backend "s3" {
    encrypt = true
    bucket = "tf-snaptrude"
    dynamodb_table = "terraform-state-lock-dynamo"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = var.vpc_cidr
  availability_zone   = var.availability_zone
  private_Subnet_cidr = var.private_Subnet_cidr
  public_Subnet_cidr  = var.public_Subnet_cidr

}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  eks_version  = var.eks_version
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  node_groups  = var.node_groups
}
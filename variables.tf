variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "availability_zone" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "private_Subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_Subnet_cidr" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cluster_name" {
  type    = string
  default = "anil-sandbox-eks-tf"
}

variable "eks_version" {
  type    = string
  default = "1.30"
}

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))

  default = {
    "sandbox-ng" = {
      instance_types = ["t2.micro", "t2.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
    },
    "sandbox-ng-2" = {
      instance_types = ["t2.micro", "t2.medium"]
      capacity_type  = "ON_DEMAND"
      scaling_config = {
        desired_size = 2
        max_size     = 3
        min_size     = 1
      }
    }
  }

}
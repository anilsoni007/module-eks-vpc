variable "vpc_cidr" {
  type = string
}

variable "availability_zone" {
  type = list(string)
}

variable "private_Subnet_cidr" {
  type = list(string)
}

variable "public_Subnet_cidr" {
  type = list(string)
}
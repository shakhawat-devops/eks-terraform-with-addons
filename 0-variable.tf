variable "region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "testing-eks-cluster"
}

variable "cluster_version" {
  default = "1.28"
}

variable "vpc" {
  default = "terraform-eks-vpc"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(any)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "node_group_name" {
  default = "eks-nodegroup"
}
variable "instance_types" {
  default = ["m6i.xlarge"]
}

variable "desired_instance_size" {
  default = "1"  
}

variable "max_instance_size" {
  default = "1"
}

variable "min_instance_size" {
  default = "1"
}
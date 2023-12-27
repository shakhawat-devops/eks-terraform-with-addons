variable "cluster_name" {
    default = "testing-eks-cluster"
}

variable "cluster_version" {
    default = "1.28"
}

variable "vpc" {
    default = "terraform-eks-vpc"
}
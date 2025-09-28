variable "unique_name" {
  description = "Provide a Environment/Project name for the deployment"
  type = string
}

variable "eks_name" {
  description = "EKS Cluster name"
  type = string
}

variable "eks_version" {
  description = "EKS Cluster name"
  type = string
}

variable "domain_name" {
  type = string
  description = "Public Domain to be created in Route53"
}

variable "vpc_cidr_block" {
  description = "Classless Inter-Domain Routing (CIDR) range for VPC"
  type = string
}

variable "no_of_pri_subs" {
  description = "Define no private subnets to create (Max 3)"
  type = number
}

variable "no_of_pub_subs" {
  description = "Define no public subnets to create (Max 3)"
  type = number
}

variable "desired_capacity" {
  description = "Number of desired instances in Auto Scaling Group"
  type = number
}

variable "min_size" {
  description = "Number of minimum instances in Auto Scaling Group"
  type = number
}

variable "max_size" {
  description = "Number of maximum instances in Auto Scaling Group"
  type = number
}

variable "instance_type" {
  description = "Instance type to create in Auto Scaling Group"
  type = string
}

variable "desired_eks_instances" {
  description = "Number of desired instances in Auto Scaling Group of EKS worker nodes"
  type = number
}

variable "min_eks_instances" {
  description = "Number of minimum instances in Auto Scaling Group of EKS worker nodes"
  type = number
}

variable "max_eks_instances" {
  description = "Number of maximum instances in Auto Scaling Group of EKS worker nodes"
  type = number
}
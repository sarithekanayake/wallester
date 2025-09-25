variable "unique_name" {
  description = "Provide a Environment/Project name for the deployment"
  type = string
  default = "wallester"
}

variable "vpc_cidr_block" {
  description = "Classless Inter-Domain Routing (CIDR) range for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "no_of_pri_subs" {
  description = "Define no private subnets to create (Max 3)"
  type = number
  default = 3
}

variable "no_of_pub_subs" {
  description = "Define no public subnets to create (Max 3)"
  type = number
  default = 3
}

variable "desired_capacity" {
  description = "Number of desired instances in Auto Scaling Group"
  type = number
  default = 2
}

variable "min_size" {
  description = "Number of minimum instances in Auto Scaling Group"
  type = number
  default = 1
}

variable "max_size" {
  description = "Number of maximum instances in Auto Scaling Group"
  type = number
  default = 3
}

variable "instance_type" {
  description = "Instance type to create in Auto Scaling Group"
  type = string
  default = "t4g.small"
}


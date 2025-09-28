#Common 
unique_name = "wallester"
domain_name = "sarithe.online"

#VPC  
vpc_cidr_block = "10.0.0.0/16"
no_of_pub_subs = 3
no_of_pri_subs = 3

#EC-2 setup  
instance_type = "t4g.small"
desired_capacity = 1
min_size = 1
max_size = 1

#EKS setup 
eks_name = "wallester-eks"
eks_version = "1.33"
desired_eks_instances = 3
min_eks_instances = 3
max_eks_instances = 8
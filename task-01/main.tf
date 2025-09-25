#------------------------
# VPC Module
#------------------------
module "vpc" {

  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//vpc?ref=v1.0.0"

  unique_name = var.unique_name

  vpc_cidr_block = var.vpc_cidr_block

  no_of_pri_subs = var.no_of_pri_subs
  no_of_pub_subs = var.no_of_pub_subs

}

#------------------------
# EC2 with HA Module
#------------------------
module "ec2-ha" {

  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//ec2-ha?ref=v1.0.0"

  unique_name = var.unique_name

  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  sg_elb_id = module.elb.sg_elb_id
  tg_arn = module.elb.target_group_arn

  desired_capacity = var.desired_capacity
  min_size = var.min_size
  max_size = var.max_size

  instance_type = var.instance_type

}

#------------------------
# ELB Module
#------------------------
module "elb" {

  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//elb?ref=v1.0.0"

  unique_name = var.unique_name

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

}
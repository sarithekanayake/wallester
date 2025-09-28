#------------------------
# Local values
#------------------------
locals {
  account_id    = data.aws_caller_identity.current.account_id
  region        = data.aws_region.current.name
}

#------------------------
# VPC Module
#------------------------
module "vpc" {

  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//vpc?ref=v1.5.0"

  unique_name = var.unique_name
  eks_name = var.eks_name

  vpc_cidr_block = var.vpc_cidr_block

  no_of_pri_subs = var.no_of_pri_subs
  no_of_pub_subs = var.no_of_pub_subs

}

#------------------------
# EC2 with HA Module
#------------------------
module "ec2-ha" {

  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//ec2-ha?ref=v1.5.0"

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

  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//elb?ref=v1.5.0"

  unique_name = var.unique_name

  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

}

#------------------------
# EKS Module
#------------------------
module "eks" {
  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//eks?ref=v1.5.0"

  # Cluster identification and K8s version
  unique_name = var.unique_name
  eks_name = var.eks_name
  eks_version = var.eks_version

  # Worker node group scaling configuration
  desired_size = var.desired_eks_instances
  max_size = var.max_eks_instances
  min_size = var.min_eks_instances

  # Networking configuration
  # EKS cluster, node group -> private subnets
  # ALB -> public subnet
  vpc_id = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids

  depends_on = [ module.vpc ]

}


#------------------------
# Route53 DNS and ACM (SSL) Module
#------------------------
module "dns" {
  source = "git::https://github.com/sarithekanayake/wallester-idp-modules.git//dns?ref=v1.5.0"

  domain_name = var.domain_name

  depends_on = [ module.eks ]
}


#------------------------
# Helm Chart Deployment (my-k8s-deployment)
#------------------------
resource "helm_release" "my-k8s-deployment" {
  name = "my-k8s-deployment"
  chart = "../helm/my-k8s-deployment"
  namespace = "default"

  # Pass values dynamically using templatefile
  values = [sensitive(templatefile("./base_values/my-k8s-deployment.yaml",
  {
    "replicas"        = "1"
    "cert_arn"        = "${module.dns.ssl_cert}"
    "public_subnets"  = join(",", module.vpc.public_subnet_ids)
    "security_groups" = join(",", [module.elb.sg_elb_id, module.eks.cluster_sg])
    "domain_name"     = "${var.domain_name}"
  }
  ))]
  depends_on = [ module.dns ]
}

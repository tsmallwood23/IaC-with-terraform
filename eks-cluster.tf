module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name = "myapp-eks-cluster"
  cluster_version = "1.22"

  subnet_ids = module.myapp-vpc.private_subnets
  #where the worker nodes will run
  vpc_id = module.myapp-vpc.vpc_id
  #you can get the module outputs from the documentation https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.26.6
  
  tags = {
    environment = "development"
    application = "myapp"

  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
    }
  }
}


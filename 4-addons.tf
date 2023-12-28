provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks_blueprints.eks_cluster_id]
    }
  }
}


module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #ensure to update this to the latest/desired version

  cluster_name      = module.eks_blueprints.eks_cluster_id
  cluster_endpoint  = module.eks_blueprints.eks_cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = module.eks_blueprints.oidc_provider

  enable_aws_load_balancer_controller = true
  enable_kube_prometheus_stack        = true
  enable_metrics_server               = true
  enable_external_dns                 = true
  enable_cert_manager                 = true
  enable_argocd                       = true
}
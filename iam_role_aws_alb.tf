module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "iam_role_alb_ingress"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks_blueprints.oidc_provider
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
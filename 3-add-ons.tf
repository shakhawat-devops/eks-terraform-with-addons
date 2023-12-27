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

resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "alb_ingress" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]


  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }


  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = module.eks_blueprints.eks_cluster_id
  }
}


resource "helm_release" "metric_server" {
  name       = "metric-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"

}

#resource "helm_release" "cert_manager" {
#  name       = "cert-manager"
#  repository = "https://charts.jetstack.io"
#  chart      = "cert-manager"
#  namespace  = "kube-system"
#
#  set {
#    name  = "installCRDs"
#    value = "true"
#  }
#}

#resource "kubernetes_service_account" "ca-service-account" {
#  metadata {
#    name = "cluster-autoscaler"
#    namespace = "kube-system"
#
#    annotations = {
#      "eks.amazonaws.com/role-arn" = aws_iam_policy.ca_policy.arn
#    }
#  }
#}

#resource "helm_release" "cluster_autoscaler" {
#  name       = "cluster-autoscaler"
#  repository = "https://kubernetes.github.io/autoscaler"
#  chart      = "cluster-autoscaler"
#  namespace  = "kube-system"
#  depends_on = [
#    kubernetes_service_account.ca-service-account
#  ]
#
#
#  set {
#    name  = "autoDiscovery.clusterName"
#    value = module.eks_blueprints.eks_cluster_id
#  }
#  set {
#    name  = "serviceAccount.name"
#    value = "cluster-autoscaler"
#  }
#}
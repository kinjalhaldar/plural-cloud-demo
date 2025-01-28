data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name

  depends_on = [ module.eks ]
}

locals {
  dns_zone_name = "qa.plural.sh"
}

resource "plural_cluster" "this" {
    handle = var.cluster
    name   = var.cluster


    tags = {
      role   = "workload" # add this to allow for global services to target only workload clusters
      tier   = var.tier
      region = var.region
    }

    metadata = jsonencode({
      dns_zone = local.dns_zone_name # reference the local variable we created above

      iam = {
        load_balancer      = module.addons.gitops_metadata.aws_load_balancer_controller_iam_role_arn
        cluster_autoscaler = module.addons.gitops_metadata.cluster_autoscaler_iam_role_arn
        external_dns       = module.externaldns_irsa_role.iam_role_arn
        cert_manager       = module.externaldns_irsa_role.iam_role_arn
      }
    })

    kubeconfig = {
      host                   = module.eks.cluster_endpoint
      cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
      token                  = data.aws_eks_cluster_auth.cluster.token
    }
}

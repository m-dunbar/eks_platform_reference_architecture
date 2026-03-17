# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/main.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.15"

  name    = local.cluster_name
  kubernetes_version = "1.35"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # node_iam_role_name = aws_iam_role.eks_node_role.name

  cluster_tags = var.tags

  eks_managed_node_groups = var.eks_managed_node_groups

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {before_compute = true}
    kube-proxy             = {}
    vpc-cni                = {before_compute = true}
  }
}

# ebs_csi_driver required for Prometheus to use EBS volumes for persistent storage
module "ebs_csi_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 1.0"

  name                   = "${local.cluster_name}-ebs-csi"
  attach_aws_ebs_csi_policy = true

  associations = {
    this = {
      cluster_name    = module.eks.cluster_name
      namespace       = "kube-system"
      service_account = "ebs-csi-controller-sa"
    }
  }

  tags = var.tags
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [module.eks]
}

# =============================================================================

# Elastic Kubernetes Service (EKS)

Amazon EKS is Amazon's managed, certified Kubernetes (K8S) service offering, running standard K8S clusters while managing the K8S control plane.

This terraform deploys a standard (albeit extremely small) EKS managed node group (creating supporting control nodes within EC2).  This provides full cluster control, with a lower cost point than Fargate or 'Auto mode' deployment models for persistent clusters.

Standard cluster management tools (`kubectl`, `helm`) can then be used to manage the cluster normally.

Deployments can proceed using `kubectl deploy`, `terraform apply`, or CI/CD pipeline.

In this example, EKS implementation is broken into multiple stages, corresponding to different Terraform apply passes, modeling different layers of requirements and dependencies, in order.

## EKS Cluster Creation (10.eks)

Initial cluster creation is performed by calling a local module 'aws/eks_cluster', which includes standardized baseline configuration elements.

## EKS Cluster-level Configuration (11.eks_config)

Implements default storage type (gp3), and namespace (monitoring).

## Application Stack -- TODO

### implementation - k8s deployment

## Supporting plugins (via helm)

**External Secrets Operator (ESO)** [chart: external-secrets] -- populates Kubernetes Secrets from AWS Secrets Manager

## Observability (#.eks-observability) -- _in progress_

_**Please Note:** Currently working through the `terraform plan` 'chicken and egg' of having to have the Custom Resource Definitions already installed in order for `plan` to evaluate the supporting helm manifests that will configure ESO and grafana._

The pragmatic solution here it to address the ordering problem by moving observability to a separate **11.eks-config**, and **#.eks-observability** terraform subsets, to be applied after the cluster is initially created, rather than attempting to overload the initial cluster creation, and to create a supporting eks_monitoring module.

Observability should be added following the addition of application workloads to be supported.  This can be performed via pure K8S yaml and kubectl, minikube or your preferred tooling if the created cluster is added to your .kube/config, or via one or more sets of supporting terraform.  (Hence, the current '#.' in the eks-observability subdirectory name.)

## Cost Comparisons of different EKS deployment models

<!-- markdownlint-disable-next-line MD036>
_(Very basic overview.  Expand later.)_

### EKS Managed Node Group -- the model implemented here

- Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
- EC2 Compute costs

The lowest cost model for persistent, predictable loads (and can use spot or reserved instances to further lower costs).  

Ideally, implementing Karpenter to provide horizontal node-level autoscaling to further reduce overhead, using relevant metrics for determining upscaling and downscaling, in addition to node rightsizing (vertical scaling) provides optimal cost management.

### Fargate

- Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
- per-vCPU and per-GB memory costs consumed (generally 2-4x those costs in EC2)

Often considerably more expensive for persistent, predictable loads, but the Fargate model eliminates idle-time overhead costs, so may be cost effective for short, burstable, low volume pods.

### Auto-mode

- Monthly control plane cost per cluster ($0.10/hour. ~$73/month)
- EC2 compute costs
- Auto Mode management fee (10-15% additional overhead)

Auto-scales nodes according to pod-based demand (basically, similar to AWS-managed Karpenter).

Auto-mode provides an on-ramp for teams with little capacity planning expertise expertise.  It _can_ be lower cost than over-provisioned Managed Node Groups, based upon potential savings via cluster node autoscaling.

---

© 2026 Matthew Dunbar  
(See LICENSE for details.)

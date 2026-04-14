---
layout: single
title: Platform Model (Runtime Domain)
---

## Purpose

This document defines the Runtime Domain of the EKS Platform Reference Architecture.

It specifies the structure, composition, and operational model of the Kubernetes runtime environment provisioned within AWS EKS.

It does not define infrastructure provisioning logic, CI/CD workflows, or application workload definitions.

It defines the **runtime system architecture only**.

---

## 1. Runtime Domain Scope

The Runtime Domain is responsible for the execution environment in which all workloads operate.

This includes:

- Amazon EKS cluster architecture
- Kubernetes control plane interaction model
- Node group topology
- Service exposure mechanisms
- Internal service networking model

---

---

## 2. Runtime Dependency Contract (Build → Runtime Boundary)

The Runtime Domain operates under explicit assumptions provided by the Build Domain.

These assumptions define the boundary between infrastructure provisioning and runtime execution.

### 2.1 Allowed Dependencies

The Runtime Domain MAY depend on the existence of:

- A provisioned EKS cluster (managed by Build Domain)
- VPC and subnet configuration
- IAM roles and identity foundations
- Node group definitions
- Networking primitives (security groups, routing)

These are considered **pre-established runtime prerequisites**.

---

### 2.2 Prohibited Dependencies

The Runtime Domain MUST NOT:

- Reference Terraform state directly
- Depend on infrastructure provisioning logic
- Define or mutate infrastructure resources
- Assume knowledge of infrastructure composition strategy

---

### 2.3 Interface Boundary Principle

The Build Domain exposes infrastructure as **capability surfaces**, not implementation details.

The Runtime Domain consumes only:

- cluster endpoints
- IAM role bindings
- networking reachability
- Kubernetes API abstractions

NOT:

- Terraform modules
- state structures
- provisioning logic

---

## 3. EKS Cluster Architecture Model

The platform is structured around a single logical EKS control plane with segmented workload execution zones.

### 3.1 Control Plane Characteristics

- Managed by AWS EKS
- Abstracted control plane lifecycle
- API server access controlled via IAM
- Cluster identity bound to AWS account-level IAM roles

---

### 3.2 Node Group Strategy

Node groups are defined as logically separated compute pools:

- System Node Group
  - Core Kubernetes system components
  - DNS, networking, cluster services

- Application Node Group(s)
  - Stateless workloads
  - Service deployments via Helm

- Optional Specialized Node Groups
  - Batch workloads
  - High-memory / compute-intensive workloads

Each node group is isolated via:

- labels
- taints/tolerations
- IAM role separation where required

---

## 4. Service Exposure Model

All external service exposure is handled through a standardized ingress abstraction.

### 4.1 Ingress Controller Strategy

The platform uses AWS-native ingress integration:

- AWS Load Balancer Controller
- Ingress resources map directly to AWS ALB provisioning
- Ingress definitions are workload-scoped (not platform-scoped)

### Constraints

- No manual LoadBalancer provisioning
- No direct ELB/ALB resource management outside Kubernetes
- Ingress is declarative and workload-owned

---

### 4.2 DNS Integration

External DNS management is handled through Kubernetes-driven automation:

- ExternalDNS controller reconciles DNS records
- DNS entries are derived from ingress/service metadata
- Route53 is treated as a declarative target system

---

## 5. Networking Model

The runtime networking model is based on VPC-native Kubernetes integration.

### Key properties

- Pods receive VPC-routable networking (CNI-based model)
- Service networking is cluster-internal unless explicitly exposed
- Security boundaries enforced via security groups and IAM

---

## 6. Workload Scheduling Model (High-Level)

The platform supports multiple workload categories:

- Stateless services
- Stateful services
- Batch processing workloads

Scheduling decisions are driven by:

- node group selection
- resource requests/limits
- affinity and toleration rules

---

## 7. Runtime Identity Model

Runtime identity is enforced through:

- IAM roles for service accounts (IRSA)
- Kubernetes service account binding to AWS IAM roles
- No static credential distribution inside workloads

---

## 8. Observability Integration (Structural Only)

The runtime layer provides hooks for observability systems but does not define their implementation.

Supported integration points:

- Metrics export endpoints
- Log stream compatibility
- Kubernetes event visibility

Actual observability stack is defined in `observability.md`.

---

## 9. Non-Goals

The Runtime Domain explicitly does NOT define:

- Terraform infrastructure provisioning (see `infrastructure.md`)
- CI/CD pipelines or GitOps workflows (see `gitops.md`)
- Application-level deployment definitions (see `workloads.md`)
- Observability stack configuration (see `observability.md`)

---

## 10. Relationship to Architecture Model

This document implements the **Runtime Domain** defined in `architecture.md`.

It must adhere to:

- domain exclusivity rules
- non-overlap constraints
- strict separation from Build and Delivery domains

---

## Summary

The Runtime Domain defines the operational structure of the EKS-based Kubernetes environment.

It establishes a controlled execution model with standardized ingress, node segmentation, IAM-based identity, and VPC-native networking integration.

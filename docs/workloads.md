# Workloads Model (Execution Domain)

## Purpose

This document defines the Execution Domain of the EKS Platform Reference Architecture.

It specifies how application workloads are structured, packaged, and deployed into the runtime environment defined in `platform.md`.

It does not define infrastructure provisioning (`infrastructure.md`), runtime cluster architecture (`platform.md`), or delivery automation (`gitops.md`).

It defines the **workload execution model only**.

---

## 1. Execution Domain Scope

The Execution Domain is responsible for defining how application components are:

- containerized
- structured for deployment
- exposed via runtime ingress
- scheduled within the Kubernetes platform

---

## 2. Workload Packaging Model

All workloads MUST be packaged as container images.

### 2.1 Containerization Standard

Each workload MUST define:

- A deterministic Dockerfile
- A reproducible build context
- Explicit dependency declaration
- Minimal runtime base images where possible

### 2.2 Dockerfile Design Principles

- Multi-stage builds SHOULD be used for production workloads
- Base images MUST be pinned to immutable versions
- No implicit system dependencies are permitted
- Runtime images SHOULD be minimized to reduce attack surface

---

## 3. Deployment Model (Helm-Based)

All workloads are deployed using Helm charts as the primary packaging mechanism.

### 3.1 Helm Responsibilities

Helm charts define:

- Kubernetes Deployment specifications
- Service definitions
- Ingress resources
- ConfigMaps and Secrets references
- Resource limits and scheduling constraints

### 3.2 Chart Structure Principle

Each workload MUST be self-contained:

- values.yaml defines environment-specific configuration
- templates define Kubernetes resource structure
- no external implicit configuration dependencies are permitted

---

## 4. Ingress Integration Model

Ingress is defined at the workload level and not at the platform level.

### Rules:

- Each workload MAY define its own ingress resources
- Ingress MUST integrate with AWS Load Balancer Controller
- Route53 records are provisioned via ExternalDNS based on ingress metadata
- No manual AWS load balancer configuration is permitted

---

## 5. Workload Classification Model

Workloads are categorized into three primary types:

### 5.1 Stateless Services

- API services
- Web applications
- Event-driven services

Characteristics:
- horizontally scalable
- no persistent local state
- externalized persistence layer

---

### 5.2 Stateful Services

- Databases (if deployed within cluster)
- Stateful processing services

Characteristics:
- persistent volume usage
- controlled scaling constraints
- strict scheduling rules

---

### 5.3 Batch / Job Workloads

- scheduled jobs
- data processing tasks
- one-off execution workloads

Characteristics:
- ephemeral execution
- restart-controlled lifecycle
- resource-intensive bursts

---

## 6. Runtime Scheduling Alignment

Workloads MUST align with the runtime model defined in `platform.md`.

This includes:

- node group selection via labels/taints
- resource requests and limits
- affinity and anti-affinity rules

Workloads MUST NOT assume specific infrastructure topology beyond what is exposed by the runtime contract.

---

---

## 7. Runtime Consumption Contract

Workloads operate under an explicit contract defined by the Runtime Domain (`platform.md`).

This contract defines what the workload MAY assume about the execution environment.

### 7.1 Allowed Assumptions

Workloads MAY assume the existence of:

- A functioning Kubernetes API server
- A schedulable node pool structure
- A CNI-based networking model
- IAM Roles for Service Accounts (IRSA)
- Ingress controller availability (AWS Load Balancer Controller)
- DNS reconciliation capability (ExternalDNS, if enabled at platform level)

These are considered **runtime guarantees provided by the platform layer**.

---

### 7.2 Forbidden Assumptions

Workloads MUST NOT assume:

- Specific node group implementations or naming
- Underlying EC2 instance types
- VPC or subnet topology
- Terraform or infrastructure provisioning logic
- Cluster lifecycle behavior

---

### 7.3 Contract Stability Principle

The Runtime Domain may evolve internally without requiring changes to workloads, provided that:

- the contract surface remains consistent
- Kubernetes API semantics are preserved
- ingress and identity models remain stable

Workloads must treat the platform as a **stable execution substrate**, not a configurable system.

---

## 8. Identity and Security Model

All workloads MUST use:

- IAM Roles for Service Accounts (IRSA)
- Kubernetes service account bindings
- No embedded static AWS credentials

Secrets SHOULD be externalized and injected via secure mechanisms.

---

## 9. Observability Hooks (Workload-Level)

Each workload SHOULD expose:

- metrics endpoints (Prometheus-compatible where applicable)
- structured logs (stdout/stderr)
- health probes (liveness/readiness)

Workloads do NOT define observability infrastructure configuration.

---

## 10. CI/CD Separation Principle

Workloads are independent of delivery pipelines.

- Build and deployment automation is defined in `gitops.md`
- Workloads define only packaging and runtime structure

---

## 11. Non-Goals

The Execution Domain explicitly does NOT define:

- Kubernetes cluster architecture (see `platform.md`)
- Infrastructure provisioning logic (see `infrastructure.md`)
- CI/CD pipeline definitions (see `gitops.md`)
- Observability stack configuration (see `observability.md`)

---

## 12. Relationship to Architecture Model

This document implements the Execution portion of the Runtime Domain defined in `architecture.md`.

It must conform to:

- domain exclusivity rules
- runtime boundary constraints
- strict separation from infrastructure and delivery domains

---

## Summary

The Execution Domain defines how application workloads are packaged, structured, and deployed into the EKS runtime environment.

It ensures consistent containerization, Helm-based deployment structure, and strict alignment with the runtime platform model.

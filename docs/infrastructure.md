# Infrastructure Model (Build Domain)

## Purpose

This document defines the Build Domain of the EKS Platform Reference Architecture.

It specifies the structural and behavioral model used to construct, organize, and maintain AWS infrastructure through Terraform.

It does not describe runtime systems, application workloads, or delivery pipelines.

It defines the **rules for infrastructure composition only**.

---

## 1. Build Domain Scope

The Build Domain is responsible for the deterministic construction of foundational platform infrastructure.

This includes:

- AWS account-level primitives
- IAM identity foundations
- cryptographic key management (KMS)
- network topology (VPC and subnet architecture)
- cluster provisioning (EKS)
- baseline data infrastructure (S3, DynamoDB)

---

## 2. Infrastructure Composition Model

Infrastructure is defined as a **layered dependency graph**, constructed in explicit order.

Each layer represents a stable domain boundary and MUST be applied independently.

### 2.1 Layered Construction Principle

Infrastructure MUST be applied in a deterministic sequence:

1. Identity Foundation (IAM / Auth providers)
2. Cryptographic Foundation (KMS)
3. State Management Foundation (S3 + DynamoDB locking)
4. Network Foundation (IPAM / VPC)
5. Compute Foundation (EKS)
6. Data Services Layer (RDS / ElastiCache)

---

## 3. State Isolation Model

Each infrastructure layer MUST maintain an independent Terraform state boundary.

### Rules:

- Each layer has a dedicated state backend configuration
- State is stored in encrypted S3 buckets
- State locking is enforced via DynamoDB
- No implicit cross-layer state coupling is permitted

---

## 4. Cross-Layer Dependency Resolution

Cross-layer dependencies MUST be resolved using explicit data-source lookups.

### Constraint Model:

- Remote state outputs SHOULD NOT be used unless no alternative exists
- Data sources are preferred for runtime resolution of dependencies
- Resource identity must be discoverable via tagging or provider APIs

This ensures:
- reduced coupling between layers
- minimized dependency fragility
- explicit runtime resolution behavior

---

## 5. Identity and Tagging Contract

All infrastructure resources MUST implement a consistent tagging model.

### Required tags:

- `environment`
- `service`
- `owner`
- `cost_center`
- `managed_by`

### Rules:

- Tags are mandatory, not optional
- Tags are used for runtime discovery and governance
- Tag schema is enforced at provisioning time

---

## 6. Terraform Module Strategy

The infrastructure model uses a hybrid approach:

- Native Terraform resources for critical primitives
- Reusable modules for stable, well-defined constructs
- Custom modules for domain-specific abstractions (e.g. EKS cluster, Auth integration)

Module design principles:

- explicit inputs only
- no hidden state assumptions
- no cross-layer implicit dependencies

---

## 7. Bootstrap and State Migration Model

The system includes a controlled bootstrap process:

### Phase 1: Local Initialization
- initial provisioning uses local Terraform state

### Phase 2: Backend Promotion
- S3 + DynamoDB backend is provisioned

### Phase 3: State Migration
- existing local state is migrated into remote backend
- encryption at rest is enforced

### Phase 4: Backend Lock-In
- all subsequent layers are required to use remote backend

This ensures:
- reproducible bootstrap
- secure state transition
- consistent backend enforcement

---

## 8. Security Model (Infrastructure Layer)

Security at the Build Domain level is enforced through:

- IAM least-privilege design
- encrypted state storage (S3 + KMS)
- strict backend access controls
- separation of identity and workload roles

Security is structural, not procedural.

---

## 9. Non-Goals

The Build Domain explicitly does NOT define:

- Kubernetes workload configuration
- CI/CD pipelines
- runtime service routing
- observability instrumentation
- application deployment models

These belong to other domains:
- Runtime → platform.md
- Delivery → gitops.md
- Observability → observability.md

---

## 10. Relationship to Architecture Model

This document is a concrete implementation of the **Build Domain** defined in `architecture.md`.

It must conform to:

- domain exclusivity rules
- non-overlap constraints
- abstraction isolation requirements

---

## Summary

The Build Domain defines a deterministic, layered infrastructure construction model using Terraform.

It enforces explicit dependency ordering, strict state isolation, and declarative identity resolution across all infrastructure components.

It serves as the foundational layer of the EKS Platform Reference Architecture.
